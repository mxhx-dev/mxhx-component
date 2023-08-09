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

	public function testSubclassWithObjectDeclaration():Void {
		var superClass = MXHXComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic">
				<mx:Declarations>
					<mx:Struct float="123.4"/>
				</mx:Declarations>
			</mx:Object>
		', {
				name: "SuperClass2",
				pack: ["mxhx", "macros", "tests"]
			});

		var subClass = MXHXComponent.withMarkup('
			<SuperClass2 xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns="mxhx.macros.tests.*">
				<mx:Declarations>
					<mx:Struct float="567.8"/>
				</mx:Declarations>
			</SuperClass2>
		');

		// this test is to ensure that the functions used to create the objects
		// don't have duplicate names. it won't compile if it fails.
		Assert.pass();
	}
}
