package mxhx.macros;

import mxhx.macros.MXHXComponent;
import utest.Assert;
import utest.Test;

class MXHXComponentSubclassTest extends Test {
	public function testSubclass():Void {
		var superClass = MXHXComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic">
				<mx:Declarations>
					<mx:Float id="float">123.4</mx:Float>
				</mx:Declarations>
			</mx:Object>
		', {
				name: "SuperClass1",
				pack: ["mxhx", "macros", "tests"]
			});

		var subClass = MXHXComponent.withMarkup('
			<SuperClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns="mxhx.macros.tests.*">
				<mx:Declarations>
					<mx:Float id="float2">567.8</mx:Float>
				</mx:Declarations>
			</SuperClass1>
		');

		Assert.equals(123.4, superClass.float);
		Assert.equals(123.4, subClass.float);
		Assert.equals(567.8, subClass.float2);
	}
}
