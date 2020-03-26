package arm;

typedef TConfig = {
	// The locale should be specified in ISO 639-1 format: https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
	// "system" is a special case that will use the system locale
	@:optional var locale: String;
	// Window
	@:optional var window_mode: Null<Int>; // window, fullscreen
	@:optional var window_w: Null<Int>;
	@:optional var window_h: Null<Int>;
	@:optional var window_x: Null<Int>;
	@:optional var window_y: Null<Int>;
	@:optional var window_resizable: Null<Bool>;
	@:optional var window_maximizable: Null<Bool>;
	@:optional var window_minimizable: Null<Bool>;
	@:optional var window_vsync: Null<Bool>;
	@:optional var window_scale: Null<Float>;
	// Render path
	@:optional var rp_supersample: Null<Float>;
	@:optional var rp_ssgi: Null<Bool>;
	@:optional var rp_ssr: Null<Bool>;
	@:optional var rp_bloom: Null<Bool>;
	@:optional var rp_motionblur: Null<Bool>;
	@:optional var rp_gi: Null<Bool>;
	// Application
	@:optional var version: String; // ArmorPaint version
	@:optional var plugins: Array<String>; // List of enabled plugins
	@:optional var bookmarks: Array<String>; // Bookmarked folders in browser
	@:optional var undo_steps: Null<Int>;	// Number of undo steps to preserve
	@:optional var keymap: String; // Link to keymap file
}