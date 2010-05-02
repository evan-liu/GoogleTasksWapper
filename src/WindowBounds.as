package {
	import flash.display.NativeWindow;
	import flash.events.NativeWindowBoundsEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class WindowBounds {
		public function WindowBounds(target:NativeWindow, fileName:String) {
			this.target = target;
			this.fileName = fileName;
			check();
			target.addEventListener(NativeWindowBoundsEvent.MOVE, changeHandler);
			target.addEventListener(NativeWindowBoundsEvent.RESIZE, changeHandler);
		}
		private var target:NativeWindow;
		private var fileName:String;
		private function check():void {
			var file:FileStream = openFile(FileMode.READ);
			if (!file) {
				return;
			}
			if (file.bytesAvailable > 0) {
				decode(file.readObject());
			}
			file.close();
		}
		private function openFile(fileMode:String):FileStream {
			var f:File = File.applicationStorageDirectory.resolvePath(fileName);
			if (!f.exists && fileMode == FileMode.READ) {
				return null;
			}
			var s:FileStream = new FileStream();
			s.open(f, fileMode);
			return s;
		}
		private function decode(source:Object):void {
			for (var p:String in source) {
				if (p in target) {
					target[p] = source[p];
				}
			}
		}
		private function encode():Object {
			return {
				"x":target.x, 
				"y":target.y, 
				"width":target.width, 
				"height":target.height
			};
		}
		private function changeHandler(event:NativeWindowBoundsEvent):void {
			var file:FileStream = openFile(FileMode.UPDATE);
			file.writeObject(encode());
			file.close();
		}
	}
}