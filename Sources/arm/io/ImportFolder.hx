package arm.io;

import zui.Nodes;
import iron.data.Data;
import iron.data.MaterialData;
import arm.ui.UITrait;
import arm.ui.UINodes;
import arm.util.RenderUtil;
import arm.util.MaterialUtil;
import arm.sys.Path;
import arm.sys.File;
import arm.node.NodesMaterial;
import arm.node.MaterialParser;
import arm.data.MaterialSlot;
import arm.Tool;
using StringTools;

class ImportFolder {

	public static function run(path:String) {
		var files = File.readDirectory(path);
		var mapbase = "";
		var mapopac = "";
		var mapnor = "";
		var mapocc = "";
		var maprough = "";
		var mapmet = "";
		var mapheight = "";

		// Import maps
		for (f in files) {
			if (!Path.isTexture(f)) continue;

			// TODO: handle -albedo

			var base = f.substr(0, f.lastIndexOf(".")).toLowerCase();
			var valid = false;
			if (mapbase == "" && Path.isBaseTex(base)) {
				mapbase = f;
				valid = true;
			}
			if (mapopac == "" && Path.isOpacTex(base)) {
				mapopac = f;
				valid = true;
			}
			if (mapnor == "" && Path.isNorTex(base)) {
				mapnor = f;
				valid = true;
			}
			if (mapocc == "" && Path.isOccTex(base)) {
				mapocc = f;
				valid = true;
			}
			if (maprough == "" && Path.isRoughTex(base)) {
				maprough = f;
				valid = true;
			}
			if (mapmet == "" && Path.isMetTex(base)) {
				mapmet = f;
				valid = true;
			}
			if (mapheight == "" && Path.isDispTex(base)) {
				mapheight = f;
				valid = true;
			}

			if (valid) ImportTexture.run(path + Path.sep + f);
		}

		// Create material
		var isScene = UITrait.inst.worktab.position == SpaceScene;
		if (isScene) {
			MaterialUtil.removeMaterialCache();
			Data.getMaterial("Scene", "Material2", function(md:MaterialData) {
				Context.materialScene = new MaterialSlot(md);
				Project.materialsScene.push(Context.materialScene);
			});
		}
		else {
			Context.material = new MaterialSlot(Project.materials[0].data);
			Project.materials.push(Context.material);
		}
		UINodes.inst.updateCanvasMap();
		var nodes = UINodes.inst.nodes;
		var canvas = UINodes.inst.canvas;
		var dirs = path.replace("\\", "/").split("/");
		canvas.name = dirs[dirs.length - 1];
		var nout:TNode = null;
		for (n in canvas.nodes) if (n.type == "OUTPUT_MATERIAL_PBR") { nout = n; break; }
		for (n in canvas.nodes) if (n.name == "RGB") { nodes.removeNode(n, canvas); break; }

		// Place nodes
		var pos = 0;
		var startY = 100;
		var nodeH = 164;
		if (mapbase != "") {
			placeImageNode(mapbase, startY + nodeH * pos, nout.id, 0);
			pos++;
		}
		if (mapopac != "") {
			placeImageNode(mapopac, startY + nodeH * pos, nout.id, 1);
			pos++;
		}
		if (mapocc != "") {
			placeImageNode(mapocc, startY + nodeH * pos, nout.id, 2);
			pos++;
		}
		if (maprough != "") {
			placeImageNode(maprough, startY + nodeH * pos, nout.id, 3);
			pos++;
		}
		if (mapmet != "") {
			placeImageNode(mapmet, startY + nodeH * pos, nout.id, 4);
			pos++;
		}
		if (mapnor != "") {
			placeImageNode(mapnor, startY + nodeH * pos, nout.id, 5);
			pos++;
		}
		if (mapheight != "") {
			placeImageNode(mapheight, startY + nodeH * pos, nout.id, 7);
			pos++;
		}

		MaterialParser.parsePaintMaterial();
		RenderUtil.makeMaterialPreview();
		UITrait.inst.hwnd1.redraws = 2;
	}

	static function placeImageNode(asset:String, ny:Int, to_id:Int, to_socket:Int) {
		var n = NodesMaterial.createNode("TEX_IMAGE");
		n.buttons[0].default_value = App.getAssetIndex(asset);
		n.x = 72;
		n.y = ny;
		var l = { id: UINodes.inst.nodes.getLinkId(UINodes.inst.canvas.links), from_id: n.id, from_socket: 0, to_id: to_id, to_socket: to_socket };
		UINodes.inst.canvas.links.push(l);
	}
}
