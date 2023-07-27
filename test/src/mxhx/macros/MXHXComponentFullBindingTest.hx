package mxhx.macros;

import fixtures.TestPropertiesClass;
import fixtures.TestPropertyEnum;
import utest.Assert;
import utest.Test;

class MXHXComponentFullBindingTest extends Test {
	public function testEscapedBindingInsideElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/mxhx" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">\\{this is not binding}</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.equals("{this is not binding}", result.string);
	}

	public function testMultipleEscapedBindingInsideElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/mxhx" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">\\{this is not binding} \\{nor is this}</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.equals("{this is not binding} {nor is this}", result.string);
	}

	public function testUnclosedNonEscapedBindingInsideElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/mxhx" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">{this is not binding</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.equals("{this is not binding", result.string);
	}

	public function testMultipleUnclosedConsecutiveEscapedBindingInsideElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/mxhx" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">\\{\\{</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.equals("{{", result.string);
	}

	public function testEscapedBindingInsideAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/mxhx" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertiesClass id="strict" string="\\{this is not binding}"/>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.equals("{this is not binding}", result.strict.string);
	}

	public function testMultipleEscapedBindingInsideAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/mxhx" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertiesClass id="strict" string="\\{this is not binding} \\{nor is this}"/>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.equals("{this is not binding} {nor is this}", result.strict.string);
	}

	public function testMultipleUnclosedConsecutiveEscapedBindingInsideAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/mxhx" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertiesClass id="strict" string="\\{\\{"/>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.equals("{{", result.strict.string);
	}

	public function testUnclosedNonEscapedBindingInsideAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/mxhx" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertiesClass id="strict" string="{this is not binding"/>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.equals("{this is not binding", result.strict.string);
	}

	public function testBindingInsideAttributeSourceProperty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/mxhx" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">hello</mx:String>
					<tests:TestPropertiesClass id="strict" string="{string}"/>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.equals("hello", result.string);
		Assert.equals("hello", result.strict.string);
	}

	public function testBindingInsideAttributeSourceConstant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/mxhx" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertiesClass id="strict" string="{fixtures.TestBindingConstantsClass.STRING}"/>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.equals("hello", result.strict.string);
	}

	public function testBindingInsideAttributeSourcePropertyConcat():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/mxhx" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">hello</mx:String>
					<tests:TestPropertiesClass id="strict" string="{string} world"/>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.equals("hello", result.string);
		Assert.equals("hello world", result.strict.string);
	}

	public function testBindingInsideAttributeSourceConstantConcat():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/mxhx" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertiesClass id="strict" string="{fixtures.TestBindingConstantsClass.STRING} world"/>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.equals("hello world", result.strict.string);
	}
}
