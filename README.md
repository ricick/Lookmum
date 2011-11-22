#Lookmum component framework

ActionScript 3 component framework based on MovieClip composition over inheritance.

##Basic usage
Components can either wrap movieclips attached from the library, or movieclips that are already in the display list.

This prevents having to state what component a particular library item is.

The following example demonstrates a base component being created with a library clip, then with a clip already on the stage, then a different subclass of component being created, that uses the same library symbol.

	package  
	{
		import com.lookmum.view.Component;
		import com.lookmum.view.Button;
		import flash.display.Sprite;
		public class ExampleComponent extends Sprite
		{
			public function ExampleComponent() 
			{
				var libraryComponent:Component = new Component(new libraryClip());
				addChild(libraryComponent);
				
				var stageComponent:Component = new Component(this.stageComponentClip);
	
				var button:Button = new Button(new libraryClip());
				addChild(button);
			}	
		}
	}
