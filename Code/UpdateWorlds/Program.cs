

var worldsDestinationDirectory = Environment.GetEnvironmentVariable("MinecraftWorlds");
var worldsSourceDirectory = $@"{Directory.GetParent($"../../../")}\Worlds";
var testOutputDirectory = $@"{Directory.GetParent($"../../../")}\TestOutput";

var worlds = Directory.GetDirectories(worldsSourceDirectory);
foreach (var world in worlds)
{
    var index = world.LastIndexOf('\\');
    var name = world[++index..];
    var destinationPath = $@"{worldsDestinationDirectory}\{name}";
    Directory.Move(world, destinationPath);
}

