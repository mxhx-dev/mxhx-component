package mxhx.macros;

import utest.Assert;
import utest.Test;

class MXHXComponentObjectTest extends Test {
	public function testEmptyTag():Void {
		var result = MXHXComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic"/>
		');
		Assert.notNull(result);
	}

	public function testOpenAndCloseTag():Void {
		var result = MXHXComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic"></mx:Object>
		');
		Assert.notNull(result);
	}

	public function testOpenAndCloseTagWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic"> </mx:Object>
		');
		Assert.notNull(result);
	}

	public function testDeclarationsEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic">
				<mx:Declarations>
					<mx:String id="string">hello</mx:String>
				</mx:Declarations>
			</mx:Object>
		');
		Assert.notNull(result);
		Assert.equals("hello", result.string);
		var superClass = Type.getSuperClass(Type.getClass(result));
		Assert.isNull(superClass);
	}
}
