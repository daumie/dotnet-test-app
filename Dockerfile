FROM mcr.microsoft.com/dotnet/core/aspnet:3.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /src
COPY ["SimpleCalc/SimpleCalc.csproj", "SimpleCalc/"]
RUN dotnet restore "SimpleCalc/SimpleCalc.csproj"
COPY . .
WORKDIR "/src/SimpleCalc"
RUN dotnet build "SimpleCalc.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "SimpleCalc.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SimpleCalc.dll"]
