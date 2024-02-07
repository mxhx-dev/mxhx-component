package mxhx.runtime;

import mxhx.runtime.MXHXRuntimeComponent.MXHXRuntimeComponentException;
import utest.Assert;
import utest.Test;

class MXHXRuntimeComponentObjectTest extends Test {
	public function testEmptyTag():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic"/>
		', idMap);
		Assert.notNull(result);
	}

	public function testOpenAndCloseTag():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic"></mx:Object>
		', idMap);
		Assert.notNull(result);
	}

	public function testOpenAndCloseTagWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic"> </mx:Object>
		', idMap);
		Assert.notNull(result);
	}

	public function testDeclarationsEmpty():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic">
				<mx:Declarations>
					<mx:String id="string">hello</mx:String>
				</mx:Declarations>
			</mx:Object>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("string"));
		var string = idMap.get("string");
		Assert.equals("hello", string);
	}

	public function testTextContent():Void {
		Assert.raises(() -> MXHXRuntimeComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic">
				text
			</mx:Object>
		'), MXHXRuntimeComponentException);
	}
}
