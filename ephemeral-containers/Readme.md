docker build . -t fjvela/ephemeral-containers-nodejs:1.0 && docker push fjvela/ephemeral-containers-nodejs:1.0

 docker build -f .\TheWeather\Dockerfile . -t fjvela/ephemeral-containers-theweather:1.0 && docker push fjvela/ephemeral-containers-theweather:1.0
  docker build -f .\TheWeather\Dockerfile.debugtools . -t fjvela/dotnet-debug-tools:6.0 && docker push fjvela/dotnet-debug-tools:6.0