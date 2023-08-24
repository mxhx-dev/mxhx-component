package mxhx.macros;

import fixtures.TestPropertiesClass;
import fixtures.TestPropertyEnum;
import utest.Assert;
import utest.Test;

class MXHXComponentBindingTagTest extends Test {
	public function testBindingToDeclaration():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/mxhx" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string1">hello</mx:String>
					<mx:String id="string2"/>
					<tests:TestPropertiesClass id="strictlyTyped"/>
				</mx:Declarations>
				<mx:Binding source="string1" destination="string2"/>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.equals("hello", result.string1);
		Assert.equals("hello", result.string2);
	}

	public function testBindingToProperty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/mxhx" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">hello</mx:String>
					<tests:TestPropertiesClass id="strictlyTyped"/>
				</mx:Declarations>
				<mx:Binding source="string" destination="strictlyTyped.string"/>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.equals("hello", result.string);
		Assert.equals("hello", result.strictlyTyped.string);
	}
}
