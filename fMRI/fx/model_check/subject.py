import numpy as np
import os
import nibabel as nib
import re
from nilearn import plotting
from nilearn.image import math_img
import pandas as pd


class Subject(object):
    """
    Class for collecting the following data for subject first-level model
    """

    def __init__(self, id, path=None):
        """
        :param id: subject ID
        :param path: path to the model directory
        """

        # define model directory path
        # if there is no path selected, use the current working directory
        if path is None:
            self.basedir = os.getcwd()
        else:
            if not os.path.exists(path):
                print('ERROR: %s does not exist!' % path)
            else:
                self.basedir = path

        # specify subject ID based on input argument id
        self.id = id

        # initialize variables
        self.con_headers = {}
        self.beta_headers = {}
        self.contrasts = {}
        self.betas = {}
        self.con_data = {}
        self.beta_data = {}

        # specify subject model directory path
        self.path = os.path.join(self.basedir, self.id)

        # get list of contrast and beta files
        self.con_files = sorted([con for con in os.listdir(self.path) if con.startswith('con')])
        self.beta_files = sorted([beta for beta in os.listdir(self.path) if beta.startswith('beta')])
        
        # execute these functions (defined below) automatically
        self.get_headers()
        self.get_contrasts()
        self.get_betas()


    def get_headers(self):
        """
        This function loads con and beta files and saves the header information as a dictionary 
        """

        self.con_headers = {}
        for c_file in self.con_files:
            self.con_headers[c_file] = {}
            fullpath = os.path.join(self.path, c_file)
            img = nib.load(fullpath)
            for key, val in zip(img.header.keys(), img.header.values()):
                self.con_headers[c_file][key] = val

        self.beta_headers = {}
        for b_file in self.beta_files:
            self.beta_headers[b_file] = {}
            fullpath = os.path.join(self.path, b_file)
            img = nib.load(fullpath)
            for key, val in zip(img.header.keys(), img.header.values()):
                self.beta_headers[b_file][key] = val


    def get_contrasts(self):
        """
        This function pulls the contrast names from the header dictionary
        """

        if not self.con_headers:
            self.get_headers()

        for file, header in self.con_headers.items():
            self.contrasts[file] = str(header['descrip']).lstrip('b').strip('\'')

    def get_betas(self):
        """
        This function pulls the beta names from the header dictionary
        """

        if not self.beta_headers:
            self.get_headers()

        for file, header in self.beta_headers.items():
            self.betas[file] = str(header['descrip']).lstrip('b').strip('\'')


    def find_contrasts(self, pattern, return_contrast=False):
        """
        This function compares a regular expression pattern to the list of contrasts 
        and returns the matching contrasts
        """

        if not self.contrasts:
            self.get_contrasts()

        good_contrasts =  []
        if return_contrast:
            good_contrasts = {}

        for file, contrast in self.contrasts.items():
            compiled_pattern = re.compile(pattern)

            if bool(compiled_pattern.search(contrast)):
                if return_contrast:
                    good_contrasts[file] = contrast
                else:
                    good_contrasts.append(file)

        return good_contrasts

    def find_betas(self, pattern, return_beta=False):
        """
        This function compares a regular expression pattern to the list of betas 
        and returns the matching betas
        """

        if not self.betas:
            self.get_betas()

        good_betas =  []
        if return_beta:
            good_betas = {}

        for file, beta in self.betas.items():
            compiled_pattern = re.compile(pattern)

            if bool(compiled_pattern.search(beta)):
                if return_beta:
                    good_betas[file] = beta
                else:
                    good_betas.append(file)

        return good_betas


    def load_contrasts(self, pattern, return_data = False):
        """
        This function loads the matching contrast nii files
        """

        load_files = self.find_contrasts(pattern)

        self.con_data = {}
        for file in load_files:
            self.con_data[file] = nib.load(os.path.join(self.path, file))

        if return_data:
            return self.con_data


    def load_betas(self, pattern, return_data = False):
        """
        This function loads the matching contrast nii files
        """

        load_files = self.find_betas(pattern)

        self.beta_data = {}
        for file in load_files:
            self.beta_data[file] = nib.load(os.path.join(self.path, file))

        if return_data:
            return self.beta_data


    def plot_data(self, con_data=None, pattern=None, contrast=True):
        """
        This function plots matching contrast or beta files
        """
        if contrast:
            if pattern:
                con_data = self.load_contrasts(pattern, return_data=True)

            if con_data is None:
                Exception("Need either con_data (loaded from load_contrasts) or regex pattern")

            for filename, con in con_data.items():
                plotting.plot_glass_brain(con, display_mode='lyrz',
                                        colorbar=True, plot_abs=False,
                                        cmap=plotting.cm.ocean_hot, title=self.id+" "+self.contrasts[filename])

        else:
            if pattern:
                beta_data = self.load_betas(pattern, return_data=True)

            if beta_data is None:
                Exception("Need either beta_data (loaded from load_betas) or regex pattern")

            for filename, beta in beta_data.items():
                plotting.plot_glass_brain(beta, display_mode='lyrz',
                                        colorbar=True, plot_abs=False,
                                        cmap=plotting.cm.ocean_hot, title=self.id+" "+self.betas[filename])


    def apply_to_pattern(self, pattern, contrast, *args):
        """
        This function applies one or more functions to the contrast or beta data 
        and returns a pandas dataframe. Args should be a list of functions.
        """
        if contrast:
            data = self.load_contrasts(pattern, return_data=True)

            all_images_values = []
            for filename, img in data.items():
                single_image_values = [self.id]
                single_image_values.append(filename)
                single_image_values.append(self.contrasts[filename])

                img_data = img.get_fdata()
                img_data = img_data[np.logical_not(np.isnan(img_data))]

                single_image_values.extend([fn(img_data) for fn in args])

                all_images_values.append(single_image_values)

            column_names = ['id', 'filename', 'contrast']
            column_names.extend([fn.__name__ for fn in args])
        
        else:
            data = self.load_betas(pattern, return_data=True)

            all_images_values = []
            for filename, img in data.items():
                single_image_values = [self.id]
                single_image_values.append(filename)
                single_image_values.append(self.betas[filename])

                img_data = img.get_fdata()
                img_data = img_data[np.logical_not(np.isnan(img_data))]

                single_image_values.extend([fn(img_data) for fn in args])

                all_images_values.append(single_image_values)

            column_names = ['id', 'filename', 'beta']
            column_names.extend([fn.__name__ for fn in args])

        df = pd.DataFrame.from_records(all_images_values, columns=column_names)
        return df



class Multisubject(object):
    """
    Given a list of subjects, this object behaves like an individual Subject, but returns a dictionary of {subject_id: results}

    eg. you can do
    multisubject.load_contrasts(...) just like subject.load_contrasts(...)

    Multisubjects is also subscriptable -- you can index the 0:2th subjects, as well as index by single or lists of subject ids

    eg.
    multisubject[0:2].load_contrasts(...)
    multisubject['sub_id_1'].load_constrasts(..)
    multisubject[['sub_id_1', 'sub_id_2']].load_contrasts(...)

    """
    def __init__(self, subjects):
        self.subjects = subjects
        self.subject_ids = [s.id for s in self.subjects]

    def __getattr__(self, name):
        attrs = [object.__getattribute__(sub, name) for sub in self.subjects]
        if hasattr(attrs[0], '__call__'):
            def newfunc(*args, **kwargs):
                result = {}
                for method, id in zip(attrs, self.subject_ids):
                    result[id] = method(*args, **kwargs)
                return result

            return newfunc
        else:
            return attrs

    def __getitem__(self, item):
        if isinstance(item, str) or isinstance(item, bytes):
            return_val = [s for s in self.subjects if s.id == item]
        if isinstance(item, list):
            return_val = [s for s in self.subjects if s.id in item]
        else:
            return_val = self.subjects[item]
        if isinstance(return_val, list):
            return Multisubject(return_val)
        else:
            return return_val



class Foo(object):
    def __getattribute__(self,name):
        attr = object.__getattribute__(self, name)
        if hasattr(attr, '__call__'):
            def newfunc(*args, **kwargs):
                print('before calling %s' %attr.__name__)
                result = attr(*args, **kwargs)
                print('done calling %s' %attr.__name__)
                return result
            return newfunc
        else:
            return attr




if __name__ == "__main__":
    subject_folders = [subdir for subdir in os.listdir(os.path.join(os.getcwd(), 'event')) if subdir.startswith("sub")]
    subject1 = Subject(id='FP001', path='/Users/jonny/git/model_check/event')
    subject.find_contrasts('Look')
    data = subject.load_contrasts('Look', return_data=True)

    data = subject.load_contrasts('Look', return_data=True)

    data = subject.apply_to_pattern("Look", np.mean, np.std, np.min, np.max)

    data = list(data.values())
    math_img("np.mean(img)", img=data)


    plotting.plot_glass_brain(data[list(data.keys())[0]], display_mode='lyrz',
                              colorbar=True, plot_abs=False,
                              cmap=plotting.cm.ocean_hot, title="test")

    ids = ["FP001", "FP002", "FP001"]
    subjects = [Subject(id=id, path='/Users/jonny/git/model_check/event') for id in ids]
    combo_data = pd.concat([s.apply_to_pattern("Look", np.mean, np.std, np.min, np.max) for s in subjects])

    combo_data = []
    for s in subjects:
        combo_data.append(...)
    combo_data = pd.concat(combo_data)


    subject.get_headers()
    subject.get_contrasts()

    subject.contrasts
    subject.con_headers.keys()
    subject.con_headers['con_0001.nii']

    multisub = Multisubject(subjects=subjects)

    multisub[0:2].load_contrasts('Look', return_data=True)














