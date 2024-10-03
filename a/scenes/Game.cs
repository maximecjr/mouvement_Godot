using Godot;
using System;

public partial class Game : Node2D
{
	public override void _Ready()
	{
		// Initialisation de la boucle principale custom
		CustomMainLoop customMainLoop = new CustomMainLoop();
		GetTree().Quit(); // Quitter l'ancienne boucle principale
	}
}
