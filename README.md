# Project 7: Deferred Renderer

**Goal:** Learn an advanced rendering technique using the OpenGL pipeline and apply it to make artistic procedural post-processing effects.

## Submission
Caroline Lachanski, clach

Demo: https://clach.github.io/homework-7-deferred-renderer-clach

I implemented Bloom (32bit), Field of View (8bit), and a CrossHatch artistic shader (8bit).

I had difficulty implementing a procedural background; I think there was something wrong with the way I was checking if a pixel was background or not, because I had nonsensical behavior when I tried to add stuff to the background. My plan was to make something like moving clouds on a blue background using FBM (you can see some of the code I already put in deferred-render.glsl).

My bloom post-process actually consisted of 3 shaders, one to extract highlights, one to blur them, and one to blend the blurred highlights with the original image. It was kind of fun to figure out where to read and write frame buffers/textures from for this shader.

I also had difficulty getting the field of view post-process to look good. I am still unable to figure out what depth, focal length, sigma, etc, values are need to get a good image (i.e. one where some objects are in focus and some are not).

For the cross hatch shader, I made use of mod functions to get patterns of lines resembling shading. I also used mod to make the background look like a piece of looseleaf.

No post-process:
![]("1.png")

Bloom:
![]("2.png")

Field of View:
![]("3.png")

CrossHatch:
![]("4.png")

Resources:

Field of View/Gaussian Blur
https://homepages.inf.ed.ac.uk/rbf/HIPR2/gsmooth.htm
http://www.stat.wisc.edu/~mchung/teaching/MIA/reading/diffusion.gaussian.kernel.pdf.pdf
https://computergraphics.stackexchange.com/questions/39/how-is-gaussian-blur-implemented

Bloom
https://learnopengl.com/Advanced-Lighting/Bloom

Cross Hatch
http://learningwebgl.com/blog/?p=2858
