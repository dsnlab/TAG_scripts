#!/usr/bin/env bash

###################################################################
#  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  #
###################################################################

###################################################################
# PARSER FOR THE INGRESS SYSTEM
#------------------------------------------------------------------
# The pipeline's ingress system maps high-level user-defined
# ingress variables to the standard variables used by the
# processing system using ingress mappings (.ing files).
###################################################################
unset    ing

###################################################################
# 1. Read the .ing file
###################################################################
mapfile  ing < ${XCPEDIR}/core/ingress/${var//\[$sub\]}.ing

###################################################################
# 2. Verify that the specified variable for ingress exists.
###################################################################
if [[ ! -s ${!var} ]]
   then
   ################################################################
   # If it doesn't exist, check for a compressed version and
   # prepare to extract it.
   #
   # The following code block handles the case of the input
   # directory being provided as a compressed tar archive. It's
   # currently reliant on some non-builtins.
   ################################################################
   var_tar=${!var}.tar.gz
   var_tgt=${!var}-extract
   if [[ -s  ${var_tar} ]]
      then
      mkdir -p    ${var_tgt}
      tar   -zxvf ${var_tar} -C ${var_tgt} >/dev/null
      #############################################################
      # This convoluted code is here in case the input is
      # compressed as a subdirectory of the provided tar
      #############################################################
      i=(${ing[1]})
      i[1]=${i[1]//'%ING'/${!var}}
      i[1]=${i[1]//'%INT'/'*'}
      try=(          $(find   ${var_tgt}  -name ${i[1]}) )
      var_untar=$(   dirname  $(abspath   ${try[0]}))
      rm    -f       ${var_tar}
      mv    -f       ${var_untar}         ${!var}
      rm    -rf      ${var_tgt}
   ################################################################
   # Sometimes, it just doesn't exist. Abort the stream if this
   # happens.
   ################################################################
   else
      abort_stream         "Invalid path provided for ${var}"
   fi
fi

###################################################################
# 3. Iterate through the mapping rules for the specified variable.
###################################################################
for i in ${!ing[@]}
   do
   i=(${ing[i]})
   i[1]=${i[1]//'%ING'/${!var}}

   case ${i[0]} in
   ################################################################
   # Metadata import: spatial
   ################################################################
   %SPACE)
      import_metadata   ${i[1]}   to   ${spaces[sub]}
      ;;

   ################################################################
   # Metadata import: derivatives
   ################################################################
   %DERIV)
      import_metadata   ${i[1]}   to   ${aux_imgs[sub]}
      ;;

   ################################################################
   # Metadata import: atlas
   ################################################################
   %ATLAS)
      import_metadata   ${i[1]}   to   ${atlas[sub]}
      ;;

   ################################################################
   # Define variable
   ################################################################
   *)
      #############################################################
      # Substitutions
      # %INT replaced by all matched integers in order
      #############################################################
      if contains ${i[1]} '%INT'
         then
         unset i_buffer
         j=0
         while (( 1 == 1 ))
            do
            x=$(abspath ${i[1]//'%INT'/${j}})
            if [[ -n ${x} ]]
               then
               i_buffer="${i_buffer} ${x}"
            else
               break
            fi
            (( j++ ))
         done
         i[1]=${i_buffer}
      fi
      
      #############################################################
      # %IDS replaced by underscore-delimited subject identifiers
      # in order
      #############################################################
      if contains ${i[1]} '%IDS'
         then
         i[1]=${i[1]//'%IDS'/${prefix[sub]}}
      fi

      #############################################################
      #TODO
      # %OR indicates to try a series of possibilities until one
      # is matched successfully
      #############################################################

      [[ -z ${i_buffer} ]]       \
         && [[ -s ${i[1]} ]]     \
         && i[1]=$(abspath ${i[1]})
      #############################################################
      # Determine whether the variable should be written to the
      # design file. ('!' at the beginning of the variable's name
      # indicates that it's for temporary use only.)
      #############################################################
      if ! contains ${i[0]} '^\!'
         then
         assign      i[1]  as ${i[0]}[sub]
         blog=${i[0]}[$sub]
         cohort_vars+=(${i[0]}[$sub])
      else
         i[0]=${i[0]#'!'}
         assign      i[1]  as ${i[0]}
      fi
      ;;

   esac
done
