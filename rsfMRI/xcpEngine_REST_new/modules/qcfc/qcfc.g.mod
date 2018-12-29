#!/usr/bin/env bash

###################################################################
#  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  ☭  #
###################################################################

###################################################################
# SPECIFIC MODULE HEADER
# This module assesses quality of functional connectivity data
###################################################################
mod_name_short=qcfc
mod_name='FUNCTIONAL QUALITY ASSESSMENT MODULE'
mod_head=${XCPEDIR}/core/CONSOLE_MODULE_RC

###################################################################
# GENERAL GROUP MODULE HEADER
###################################################################
source ${XCPEDIR}/core/constants
source ${XCPEDIR}/core/functions/library.sh
source ${XCPEDIR}/core/parseArgsGroup

###################################################################
# MODULE COMPLETION AND ANCILLARY FUNCTIONS
###################################################################
atlas_complete() {
   quality_metric    QCFCnSigEdges${a[Name]^}          qcfc_n_sig_edges
   quality_metric    QCFCpctSigEdges${a[Name]^}        qcfc_pct_sig_edges
   quality_metric    QCFCabsMedCor${a[Name]^}          qcfc_abs_med_cor
   quality_metric    QCFCdistanceDependence${a[Name]^} qcfc_dist_dependence
}
completion() {
   quality[sub]=${quality_group}
   source ${XCPEDIR}/core/updateQuality
   source ${XCPEDIR}/core/moduleEnd
}





###################################################################
# OUTPUTS
###################################################################
declare_atlas_outputs() {
   define   qcfc_n_sig_edges        ${outdir}/${sequence}_QC-FC_nSigEdges_${a[Name]}.txt
   define   qcfc_pct_sig_edges      ${outdir}/${sequence}_QC-FC_pctSigEdges_${a[Name]}.txt
   define   qcfc_abs_med_cor        ${outdir}/${sequence}_QC-FC_absMedCor_${a[Name]}.txt
   define   qcfc_base               ${outdir}/${sequence}_QC-FC_correlation_${a[Name]}
   define   qcfc_dist_dependence    ${outdir}/${sequence}_QC-FC_distanceDependence_${a[Name]}.txt
   define   qcfc_dist_dependence_f  ${outdir}/${sequence}_QC-FC_distanceDependence_${a[Name]}.svg
   define   qcfc_correlation        ${outdir}/${sequence}_QC-FC_correlation_${a[Name]}.txt
   define   qcfc_correlation_thr    ${outdir}/${sequence}_QC-FC_correlation_thr_${a[Name]}.txt
   define   node_distance           ${outdir}/${sequence}_node_distance_${a[Name]}.txt
}

<<DICTIONARY

node_distance
   A matrix indicating the pairwise distance between the nodes of
   the analysed network
qcfc_abs_med_cor
   The absolute median correlation between connectivity and motion
   across all edges in the network
qcfc_correlation
   The QC-FC matrix: the weight of each edge is equal to the
   correlation between functional connectivity along that edge and
   subject motion
qcfc_correlation_thr
   Thresholded version of qcfc_correlation: all non-significant
   edges are set to 0
qcfc_dist_dependence
   The edgewise correlation between QC-FC values and edge length
   (Euclidean distance between connected nodes)
qcfc_n_sig_edges
   The number of edges in the network whose strength is related
   significantly to subject motion
qcfc_pct_sig_edges
   The percentage of edges in the network whose strength is related
   significantly to subject motion

DICTIONARY










###################################################################
# Retrieve all the networks for which quality assessment should be
# run, and prime the analysis.
###################################################################
if [[ -s ${atlas_orig} ]]
   then
   subroutine                 @0.1
   load_atlas        ${atlas_orig}
else
   echo \
"
::XCP-WARNING: Quality assessment of functional connectivity data
  has been requested, but no functional connectivity data have been
  provided.
  
  Skipping module"
   exit 1
fi





###################################################################
# Retrieve all motion estimates.
# qm should probably be a hash table.
###################################################################
routine                       @1    Obtaining motion estimates
subroutine                    @1.1  Scanning subject-level quality metrics
unset    v     motion
for sub in ${subjects[@]}
   do
   unset    qa
   mapfile  qa < ${quality[sub]}
   qvarsub=( ${qa[0]//,/ } )
   qvalsub=( ${qa[1]//,/ } )
   if [[ -z ${v} ]]
      then
      for v in ${!qvarsub[@]}; do contains ${qvarsub[v]} relMeanRMSMotion && break; done
   fi
   motion[sub]=${qvalsub[v]}
done
routine_end





###################################################################
# Iterate through each brain atlas. Compute the QC-FC measures for
# each.
###################################################################
for map in ${atlas_names[@]}
   do
   atlas_parse       ${map}
   atlas_check       || continue
   declare_atlas_outputs
   unset edges
   ################################################################
   # Iterate over all subjects's atlantes.
   ################################################################
   routine                    @2    QC-FC: ${a[Name]}
   subroutine                 @2.1  Atlas: ${a[Name]}
   subroutine                 @2.2  Scanning subject-level atlas metadata
   exec_sys rm -f                            ${intermediate}-${a[Name]}-subjects.csv
   echo ${ids[0]},connectivity,motion     >> ${intermediate}-${a[Name]}-subjects.csv
   for sub in ${subjects[@]}
      do
      load_atlas     ${atlas[sub]}
      atlas_parse    ${map}
      edges[sub]=${a[MatrixFC]}
      echo ${ids[sub]},${edges[sub]},${motion[sub]}   >> ${intermediate}-${a[Name]}-subjects.csv
   done
   load_atlas        ${atlas_orig}
   atlas_parse       ${map}





   ################################################################
   # Build the edgewise FC correlation matrix.
   # Pass in confounds if they have been provided.
   ################################################################
   subroutine                 @2.3  QC-FC matrix: correlations with motion
   rm -f ${outbase}quality
   [[ -e ${qcfc_confmat[cxt]} ]] \
      && confound="  -n ${qcfc_confmat[cxt]}" \
      && conformula="-y ${qcfc_conformula[cxt]}"
   if [[ ! -s ${qcfc_correlation[cxt]} ]] \
   || rerun
      then
      exec_sys rm -f ${qcfc_base[cxt]}*
      exec_xcp qcfc.R                                    \
         -c    ${intermediate}-${a[Name]}-subjects.csv   \
         -s    ${qcfc_sig[cxt]}                          \
         -o    ${qcfc_base[cxt]}                         \
         ${confound} ${conformula}
      exec_sys mv ${qcfc_base[cxt]}_absMedCor.txt \
                  ${qcfc_abs_med_cor[cxt]}
      exec_sys mv ${qcfc_base[cxt]}_nSigEdges.txt \
                  ${qcfc_n_sig_edges[cxt]}
      exec_sys mv ${qcfc_base[cxt]}_pctSigEdges.txt \
                  ${qcfc_pct_sig_edges[cxt]}
   fi





   ################################################################
   # Compute the overall correlation between distance and motion
   # effects to infer distance-dependence of motion effects.
   ################################################################
   subroutine                 @2.4  Computing QC-FC distance-dependence
   exec_xcp qcfcDistanceDependence        \
      -a    ${a[Map]}                     \
      -q    ${qcfc_correlation[cxt]}      \
      -o    ${qcfc_dist_dependence[cxt]}  \
      -f    ${qcfc_dist_dependence_f[cxt]}\
      -d    ${node_distance[cxt]}         \
      -i    ${intermediate}
   atlas_complete
   routine_end
done





completion
