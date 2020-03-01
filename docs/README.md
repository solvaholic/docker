# solvaholic/docker

See something you like? See something you'd do different? [Let me know](https://github.com/solvaholic/docker/issues/new/choose) :heart:

I created this project to build and publish Dockerfiles. There's already [an example workflow]() to build and push your Dockerfile. That's what I started with here.

If your project has only one Dockerfile, use that :point_up:.

With this workflow you can manage a collection of Dockerfiles in directories named after their applications:

1. Push changes to `/app-name/Dockerfile`.
2. The Actions workflow builds the image and pushes it to docker.pkg.github.com.
