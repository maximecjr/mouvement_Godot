using Godot;

[GlobalClass]
public partial class CustomMainLoop : SceneTree
{	
	private static CustomMainLoop _instance;
	private LevelManager _levelManager;
	private SaveManager _saveManager;
	
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

	}
	
		public override bool _Process(double delta)
	{
		// Return true to end the main loop.
		if (Input.IsKeyPressed(Key.Escape)) // ui_cancel est généralement mappé à Échap
		{
			_Finalize();
		}
		return Input.IsKeyPressed(Key.Escape);
	}
	
	 private void _Finalize()
	{
		GD.Print("Finalized:");
	}


}
