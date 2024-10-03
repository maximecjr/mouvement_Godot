using Godot;
using System.IO;

public class SaveManager
{
	public void LoadGame(string filePath)
	{
		if (File.Exists(filePath))
		{
			// Logique de chargement de la sauvegarde
			var data = File.ReadAllText(filePath);
			GD.Print("Loaded game data: " + data);
		}
		else
		{
			GD.PrintErr("Save file not found: " + filePath);
		}
	}

	public void SaveGame(string filePath)
	{
		// Logique pour écrire la sauvegarde
		File.WriteAllText(filePath, "Saved game data");
		GD.Print("Game saved to: " + filePath);
	}
}
