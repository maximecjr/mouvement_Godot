using Godot;
using System.IO;
using System.Text.Json;

public class SaveManager
{
	// Structure pour contenir les données du jeu
	public class GameData
	{
		public float[] PlayerPosition { get; set; }  // Sauvegarde la position du joueur
		public float ProgressBarValue { get; set; }  // Sauvegarde la valeur de la barre de progression
	}

	public void LoadGame(string filePath, CharacterBody2D player, TextureProgressBar progressBar)
	{
		if (File.Exists(filePath))
		{
			var jsonData = File.ReadAllText(filePath);
			var data = JsonSerializer.Deserialize<GameData>(jsonData);

			if (data != null)
			{
				// Charger la position du joueur
				player.Position = new Vector2(data.PlayerPosition[0], data.PlayerPosition[1]);
				GD.Print("Position du joueur chargée : " + player.Position);

				// Charger la valeur de la barre de progression
				progressBar.Value = (double)data.ProgressBarValue;
				GD.Print("Valeur de la barre de progression chargée : " + progressBar.Value);
			}
		}
		else
		{
			GD.PrintErr("Fichier de sauvegarde non trouvé : " + filePath);
		}
	}

	public void SaveGame(string filePath, CharacterBody2D player, TextureProgressBar progressBar)
	{
		// Crée les données du jeu
		GameData data = new GameData
		{
			PlayerPosition = new float[] { player.Position.X, player.Position.Y },
			ProgressBarValue = (float)progressBar.Value
		};

		GD.Print("data : " + data);
		var jsonData = JsonSerializer.Serialize(data);
		GD.Print("json : " + jsonData);
		File.WriteAllText(filePath, jsonData);

		GD.Print("Jeu sauvegardé avec la position du joueur : " + player.Position);
		GD.Print("Jeu sauvegardé avec la valeur de la barre de progression : " + progressBar.Value);
	}
}
