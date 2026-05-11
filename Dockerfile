FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Note the exact spelling from your screenshot
COPY ["BugLoggerApi.csproj", "./"]
RUN dotnet restore "BugLoggerApi.csproj"

COPY . .
# Using the project file here is safer than the solution file
RUN dotnet publish "BugLoggerApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Check your Program.cs - the assembly name is usually the same as the .csproj
ENTRYPOINT ["dotnet", "BugLoggerApi.dll"]