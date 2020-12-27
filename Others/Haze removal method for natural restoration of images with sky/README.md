# F-LDCP
The official code of paper "Haze removal method for natural restoration of images with sky" by Zhu et al.(Neurocomputing 2018). The input is an haze image, and the output is an dehaze image. Fusion of Luminance and Dark Channel Prior (F-LDCP) method effectively restore long-shot images with sky. The transmission values estimated based on a luminance model and dark channel prior model are fused together based on a soft segmentation. The transmission estimated from the luminance model mainly contributes to the sky region, while that from the dark channel prior for the foreground region.

## MATLAB code
## Usage
Put your haze image into 'image' file, run the following code and the dehaze result will show up.
```
matlab main.m
```
  
## Example of result
![](https://github.com/tygrer/F-LDCP/blob/master/image/150127172751-kuala-lumpur-haze-2013-super-169.jpg) 
![](https://github.com/tygrer/F-LDCP/blob/master/result/_150127172751-kuala-lumpur-haze-2013-super-169.jpg)
