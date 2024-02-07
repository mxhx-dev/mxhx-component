package mxhx.runtime;

import fixtures.TestClass1;
import fixtures.TestPropertiesClass;
import fixtures.TestPropertyEnum;
import mxhx.runtime.MXHXRuntimeComponent.MXHXRuntimeComponentException;
import utest.Assert;
import utest.Test;

class MXHXRuntimeComponentBasicBindingTest extends Test {
	public function tesRaisesExceptionForUnescapedBinding1():Void {
		Assert.raises(() -> MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">{realBinding}</mx:String>
				</mx:Declarations>
			</tests:TestClass1>'), MXHXRuntimeComponentException);
	}

	public function tesRaisesExceptionForUnescapedBinding2():Void {
		Assert.raises(() -> MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Struct id="struct" field="{realBinding}"/>
				</mx:Declarations>
			</tests:TestClass1>'), MXHXRuntimeComponentException);
	}

	public function tesRaisesExceptionForUnescapedBinding3():Void {
		Assert.raises(() -> MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Struct id="struct">
						<mx:field>{realBinding}</mx:field>
					</mx:Struct>
				</mx:Declarations>
			</tests:TestClass1>'), MXHXRuntimeComponentException);
	}

	public function testEscapedBindingInsideElement():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">\\{this is not binding}</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("string"));
		var string = idMap.get("string");
		Assert.equals("{this is not binding}", string);
	}

	public function testMultipleEscapedBindingInsideElement():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">\\{this is not binding} \\{nor is this}</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("string"));
		var string = idMap.get("string");
		Assert.equals("{this is not binding} {nor is this}", string);
	}

	public function testUnclosedNonEscapedBindingInsideElement():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">{this is not binding</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("string"));
		var string = idMap.get("string");
		Assert.equals("{this is not binding", string);
	}

	public function testMultipleUnclosedConsecutiveEscapedBindingInsideElement():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string">\\{\\{</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("string"));
		var string = idMap.get("string");
		Assert.equals("{{", string);
	}

	public function testEscapedBindingInsideAttribute():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertiesClass id="strictlyTyped" string="\\{this is not binding}"/>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("strictlyTyped"));
		var strictlyTyped = Std.downcast((idMap.get("strictlyTyped") : Dynamic), TestPropertiesClass);
		Assert.equals("{this is not binding}", strictlyTyped.string);
	}

	public function testMultipleEscapedBindingInsideAttribute():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertiesClass id="strictlyTyped" string="\\{this is not binding} \\{nor is this}"/>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("strictlyTyped"));
		var strictlyTyped = Std.downcast((idMap.get("strictlyTyped") : Dynamic), TestPropertiesClass);
		Assert.equals("{this is not binding} {nor is this}", strictlyTyped.string);
	}

	public function testMultipleUnclosedConsecutiveEscapedBindingInsideAttribute():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertiesClass id="strictlyTyped" string="\\{\\{"/>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("strictlyTyped"));
		var strictlyTyped = Std.downcast((idMap.get("strictlyTyped") : Dynamic), TestPropertiesClass);
		Assert.equals("{{", strictlyTyped.string);
	}

	public function testUnclosedNonEscapedBindingInsideAttribute():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:TestPropertiesClass id="strictlyTyped" string="{this is not binding"/>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isOfType(result, TestClass1);
		Assert.isTrue(idMap.exists("strictlyTyped"));
		var strictlyTyped = Std.downcast((idMap.get("strictlyTyped") : Dynamic), TestPropertiesClass);
		Assert.equals("{this is not binding", strictlyTyped.string);
	}
}
