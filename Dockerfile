# FROM mcr.microsoft.com/dotnet/sdk:6.0
# WORKDIR /app

# # Copy everything
# COPY . ./
# # Setting Argument Port
# ARG PORTAPP=6500
# # Setting Env var port
# ENV PORT=$PORTAPP
# # Build Dotnet API
# RUN dotnet build
# # Export port
# EXPOSE $PORT
# # Start API
# CMD ["dotnet", "run"]

FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine as build
WORKDIR /app
COPY . .
RUN dotnet sln add devopsTest.csproj
RUN dotnet restore
RUN dotnet publish -o /app/published-app

FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine as runtime
WORKDIR /app
COPY --from=build /app/published-app /app
ARG PORTAPP=6500
ENV PORT=$PORTAPP
RUN apk update
RUN apk upgrade
RUN apk add bash nano
EXPOSE $PORT
ENTRYPOINT [ "dotnet", "/app/devopsTest.dll" ]

