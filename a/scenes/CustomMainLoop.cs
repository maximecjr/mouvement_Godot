using Godot;

[GlobalClass]
public partial class CustomMainLoop : SceneTree
{
	private static CustomMainLoop _instance;
	private LevelManager _levelManager;
	private SaveManager _saveManager;
	private CharacterBody2D _player; // Reference to the player
	private TextureProgressBar _progressBar;
	
	public CustomMainLoop()
	{
		_instance = this;
		_levelManager = new LevelManager();
		_saveManager = new SaveManager();
	}

	public static CustomMainLoop Get()
	{
		return _instance;
	}

	public LevelManager GetLevelManager()
	{
		return _levelManager;
	}

	public SaveManager GetSaveManager()
	{
		return _saveManager;
	}

	public override void _Initialize()
	{
		GD.Print("Initialized:");
		_levelManager.LoadGame("res://scenes/game.tscn");

		// Get the player from the current scene
		_player = GetCurrentScene().GetNode<CharacterBody2D>("Player");

		_progressBar = GetCurrentScene().GetNode<TextureProgressBar>("CanvasLayer/StaminaBar/TextureProgress");

		// Load the player's saved position
		_saveManager.LoadGame("savegame.json", _player, _progressBar);
	}

	public override bool _Process(double delta)
	{
		// Save the game when the player presses 'G'
		if (Input.IsKeyPressed(Key.G))
		{
			GD.Print("Progress bar :  " + _progressBar);
			_saveManager.SaveGame("savegame.json", _player, _progressBar);
		}

		// Quit and save when the player presses Escape
		if (Input.IsKeyPressed(Key.Escape))
		{
			_saveManager.SaveGame("savegame.json", _player, _progressBar);
			_Finalize();
		}
		return Input.IsKeyPressed(Key.Escape);
	}

	private void _Finalize()
	{
		GD.Print("Finalized:");
	}
}
