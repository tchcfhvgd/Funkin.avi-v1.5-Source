package;

import flixel.FlxG;
import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
#if sys
import sys.io.File;
import sys.FileSystem;
#else
import openfl.utils.Assets;
#end

using StringTools;

class CoolUtil
{
	public static var defaultDifficulties:Array<String> = [
		'Hard',
		'Suicidal',
		'X2'
	];
	public static var defaultDifficulty:String = 'Hard'; //The chart that has no suffix and starting difficulty on Freeplay/Story Mode

	public static var difficulties:Array<String> = [];

	#if desktop
	public static function openDumbFile(path:String){
		if(!FileSystem.exists(path)){
			var timer:Float = 0;
			while(!FileSystem.exists(path)){
				timer += FlxG.elapsed;
				if(timer>2)break;
			};
		}
		if(FileSystem.exists(path)){
			Sys.command('start "" "$path"');
		}else{
			trace("The File Doesnt't Exist BRUH");
		}
	}
	#end

	public static function getDifficultyFilePath(num:Null<Int> = null)
		{
			if(num == null) num = PlayState.storyDifficulty;
	
			var fileSuffix:String = difficulties[num];
			if(fileSuffix != defaultDifficulty)
			{
				fileSuffix = '-' + fileSuffix;
			}
			else
			{
				fileSuffix = '';
			}
			return Paths.formatToSongPath(fileSuffix);
		}
	
		public static function difficultyString():String
		{
			return difficulties[PlayState.storyDifficulty].toUpperCase();
		}
	
		inline public static function boundTo(value:Float, min:Float, max:Float):Float {
			return Math.max(min, Math.min(max, value));
		}
	
		public static function coolTextFile(path:String):Array<String>
		{
			var daList:Array<String> = [];
			
			if(Assets.exists(path)) daList = Assets.getText(path).trim().split('\n');
			
			for (i in 0...daList.length)
			{
				daList[i] = daList[i].trim();
			}
	
			return daList;
		}
		
		public static function coolReplace(string:String, sub:String, by:String):String
			return string.split(sub).join(by);
	
		//Example: "winter-horrorland" to "Winter Horrorland". Used for replays
		public static function coolSongFormatter(song:String):String
		{
			var swag:String = coolReplace(song, '-', ' ');
			var splitSong:Array<String> = swag.split(' ');
	
			for (i in 0...splitSong.length)
			{
				var firstLetter = splitSong[i].substring(0, 1);
				var coolSong:String = coolReplace(splitSong[i], firstLetter, firstLetter.toUpperCase());
				var splitCoolSong:Array<String> = coolSong.split('');
	
				coolSong = Std.string(splitCoolSong[0]).toUpperCase();
	
				for (e in 0...splitCoolSong.length)
					coolSong += Std.string(splitCoolSong[e+1]).toLowerCase();
	
				coolSong = coolReplace(coolSong, 'null', '');
	
				for (l in 0...splitSong.length)
				{
					var stringSong:String = Std.string(splitSong[l+1]);
					var stringFirstLetter:String = stringSong.substring(0, 1);
	
					var splitStringSong = stringSong.split('');
					stringSong = Std.string(splitStringSong[0]).toUpperCase();
	
					for (l in 0...splitStringSong.length)
						stringSong += Std.string(splitStringSong[l+1]).toLowerCase();
	
					stringSong = coolReplace(stringSong, 'null', '');
	
					coolSong += ' $stringSong';
				}
	
				song = coolSong.replace(' Null', '');
				return song;
			}
	
			return swag;
		}
	
		#if sys
		public static function coolPathArray(path:String):Array<String>
		{
			return HSys.readDirectory(path);
		}
		#end
	
		public static function listFromString(string:String):Array<String>
		{
			var daList:Array<String> = [];
			daList = string.trim().split('\n');
	
			for (i in 0...daList.length)
			{
				daList[i] = daList[i].trim();
			}
	
			return daList;
		}
		public static function dominantColor(sprite:flixel.FlxSprite):Int{
			var countByColor:Map<Int, Int> = [];
			for(col in 0...sprite.frameWidth){
				for(row in 0...sprite.frameHeight){
				  var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
				  if(colorOfThisPixel != 0){
					  if(countByColor.exists(colorOfThisPixel)){
						countByColor[colorOfThisPixel] =  countByColor[colorOfThisPixel] + 1;
					  }else if(countByColor[colorOfThisPixel] != 13520687 - (2*13520687)){
						 countByColor[colorOfThisPixel] = 1;
					  }
				  }
				}
			 }
			var maxCount = 0;
			var maxKey:Int = 0;//after the loop this will store the max color
			countByColor[flixel.util.FlxColor.BLACK] = 0;
				for(key in countByColor.keys()){
				if(countByColor[key] >= maxCount){
					maxCount = countByColor[key];
					maxKey = key;
				}
			}
			return maxKey;
		}
	
		public static function numberArray(max:Int, ?min = 0):Array<Int>
		{
			var dumbArray:Array<Int> = [];
			for (i in min...max)
			{
				dumbArray.push(i);
			}
			return dumbArray;
		}
	
		//uhhhh does this even work at all? i'm starting to doubt
		public static function precacheSound(sound:String, ?library:String = null):Void {
			precacheSoundFile(Paths.sound(sound, library));
		}
	
		public static function precacheMusic(sound:String, ?library:String = null):Void {
			precacheSoundFile(Paths.music(sound, library));
		}
	
		private static function precacheSoundFile(file:Dynamic):Void {
			if (Assets.exists(file, SOUND) || Assets.exists(file, MUSIC))
				Assets.getSound(file, true);
		}
	
		public static function browserLoad(site:String) {
			#if linux
			Sys.command('/usr/bin/xdg-open', [site]);
			#else
			FlxG.openURL(site);
			#end
		}
	}
