using Godot;

public class LevelManager
{
	// Note: This can be called from anywhere inside the tree. This function is
// path independent.
	public void LoadGame(string scenePath)
	{
		 // Vérifie si la scène existe
		if (ResourceLoader.Exists(scenePath))
		{
			// Charge la scène
			GD.Load<PackedScene>(scenePath);
		}
		else
		{
			GD.PrintErr("La scène n'existe pas : " + scenePath);
		}
		}
}
