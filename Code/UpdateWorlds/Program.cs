

static void CopyFilesRecursively(string sourcePath, string targetPath)
{
    //Now Create all of the directories
    foreach (string dirPath in Directory.GetDirectories(sourcePath, "*", SearchOption.AllDirectories))
    {
        Directory.CreateDirectory(dirPath.Replace(sourcePath, targetPath));
    }

    //Copy all the files & Replaces any files with the same name
    foreach (string newPath in Directory.GetFiles(sourcePath, "*.*", SearchOption.AllDirectories))
    {
        File.Copy(newPath, newPath.Replace(sourcePath, targetPath), true);
    }
}

var worldsDestinationDirectory = Environment.GetEnvironmentVariable("MinecraftWorlds");
var worldsSourceDirectory = $@"{Directory.GetParent($"../../../")}\Worlds";
var testOutputDirectory = $@"{Directory.GetParent($"../../../")}\TestOutput";

var worlds = Directory.GetDirectories(worldsSourceDirectory);
foreach (var world in worlds)
{
    var index = world.LastIndexOf('\\');
    var name = world[++index..];
    var destinationPath = $@"{worldsDestinationDirectory}\{name}";
    CopyFilesRecursively(world, destinationPath);
}

