package mxhx.macros;

import Xml.XmlType;
import fixtures.ModuleWithClassThatHasDifferentName.ThisClassHasADifferentNameThanItsModule;
import fixtures.TestAbstractFromModuleType.ModuleType;
import fixtures.TestComplexEnum;
import fixtures.TestPropertiesClass;
import fixtures.TestPropertyAbstractEnum;
import fixtures.TestPropertyEnum;
import utest.Assert;
import utest.Test;

class MXHXComponentPropertyTest extends Test {
	public function testStructChildElementAttributes():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:struct>
					<mx:Struct float="123.4" float_hex="0xbeef" nan="NaN" boolean_true="true" boolean_false="false" string="hello"/>
				</tests:struct>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.notNull(result.struct);
		Assert.equals(6, Reflect.fields(result.struct).length);
		Assert.isTrue(Reflect.hasField(result.struct, "float"));
		Assert.isTrue(Reflect.hasField(result.struct, "float_hex"));
		Assert.isTrue(Reflect.hasField(result.struct, "nan"));
		Assert.isTrue(Reflect.hasField(result.struct, "boolean_true"));
		Assert.isTrue(Reflect.hasField(result.struct, "boolean_false"));
		Assert.isTrue(Reflect.hasField(result.struct, "string"));
		Assert.equals(123.4, Reflect.field(result.struct, "float"));
		Assert.equals(0xbeef, Reflect.field(result.struct, "float_hex"));
		Assert.isTrue(Math.isNaN(Reflect.field(result.struct, "nan")));
		Assert.isTrue(Reflect.field(result.struct, "boolean_true"));
		Assert.isFalse(Reflect.field(result.struct, "boolean_false"));
		Assert.equals("hello", Reflect.field(result.struct, "string"));
	}

	public function testStructChildElementAttributesExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:struct>
					<mx:Struct float=" 123.4 " float_hex=" 0xbeef " nan=" NaN " boolean_true=" true " boolean_false=" false " string=" hello "/>
				</tests:struct>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.notNull(result.struct);
		Assert.equals(6, Reflect.fields(result.struct).length);
		Assert.isTrue(Reflect.hasField(result.struct, "float"));
		Assert.isTrue(Reflect.hasField(result.struct, "float_hex"));
		Assert.isTrue(Reflect.hasField(result.struct, "nan"));
		Assert.isTrue(Reflect.hasField(result.struct, "boolean_true"));
		Assert.isTrue(Reflect.hasField(result.struct, "boolean_false"));
		Assert.isTrue(Reflect.hasField(result.struct, "string"));
		Assert.equals(123.4, Reflect.field(result.struct, "float"));
		Assert.equals(0xbeef, Reflect.field(result.struct, "float_hex"));
		Assert.isTrue(Math.isNaN(Reflect.field(result.struct, "nan")));
		Assert.isTrue(Reflect.field(result.struct, "boolean_true"));
		Assert.isFalse(Reflect.field(result.struct, "boolean_false"));
		Assert.equals(" hello ", Reflect.field(result.struct, "string"));
	}

	public function testStructChildElementChildren():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:struct>
					<mx:Struct>
						<mx:float>123.4</mx:float>
						<mx:float_hex>0xbeef</mx:float_hex>
						<mx:nan>NaN</mx:nan>
						<mx:boolean_true>true</mx:boolean_true>
						<mx:boolean_false>false</mx:boolean_false>
						<mx:string>hello</mx:string>
						<mx:object>
							<mx:Struct>
								<mx:integer>567</mx:integer>
							</mx:Struct>
						</mx:object>
					</mx:Struct>
				</tests:struct>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.notNull(result.struct);
		Assert.equals(7, Reflect.fields(result.struct).length);
		Assert.isTrue(Reflect.hasField(result.struct, "float"));
		Assert.isTrue(Reflect.hasField(result.struct, "float_hex"));
		Assert.isTrue(Reflect.hasField(result.struct, "nan"));
		Assert.isTrue(Reflect.hasField(result.struct, "boolean_true"));
		Assert.isTrue(Reflect.hasField(result.struct, "boolean_false"));
		Assert.isTrue(Reflect.hasField(result.struct, "string"));
		Assert.isTrue(Reflect.hasField(result.struct, "object"));
		Assert.equals(123.4, Reflect.field(result.struct, "float"));
		Assert.equals(0xbeef, Reflect.field(result.struct, "float_hex"));
		Assert.isTrue(Math.isNaN(Reflect.field(result.struct, "nan")));
		Assert.isTrue(Reflect.field(result.struct, "boolean_true"));
		Assert.isFalse(Reflect.field(result.struct, "boolean_false"));
		Assert.equals("hello", Reflect.field(result.struct, "string"));
		Assert.notNull(Reflect.field(result.struct, "object"));
		Assert.equals(1, Reflect.fields(result.struct.object).length);
		Assert.equals(567, Reflect.field(Reflect.field(result.struct, "object"), "integer"));
	}

	public function testStructChildElementChildrenExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:struct>
					<mx:Struct>
						<mx:float>
							123.4
						</mx:float>
						<mx:float_hex>
							0xbeef
						</mx:float_hex>
						<mx:nan>
							NaN
						</mx:nan>
						<mx:boolean_true>
							true
						</mx:boolean_true>
						<mx:boolean_false>
							false
						</mx:boolean_false>
						<mx:string> hello </mx:string>
						<mx:object>
							<mx:Struct>
								<mx:integer>
									567
								</mx:integer>
							</mx:Struct>
						</mx:object>
					</mx:Struct>
				</tests:struct>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.notNull(result.struct);
		Assert.equals(7, Reflect.fields(result.struct).length);
		Assert.isTrue(Reflect.hasField(result.struct, "float"));
		Assert.isTrue(Reflect.hasField(result.struct, "float_hex"));
		Assert.isTrue(Reflect.hasField(result.struct, "nan"));
		Assert.isTrue(Reflect.hasField(result.struct, "boolean_true"));
		Assert.isTrue(Reflect.hasField(result.struct, "boolean_false"));
		Assert.isTrue(Reflect.hasField(result.struct, "string"));
		Assert.isTrue(Reflect.hasField(result.struct, "object"));
		Assert.equals(123.4, Reflect.field(result.struct, "float"));
		Assert.equals(0xbeef, Reflect.field(result.struct, "float_hex"));
		Assert.isTrue(Math.isNaN(Reflect.field(result.struct, "nan")));
		Assert.isTrue(Reflect.field(result.struct, "boolean_true"));
		Assert.isFalse(Reflect.field(result.struct, "boolean_false"));
		Assert.equals(" hello ", Reflect.field(result.struct, "string"));
		Assert.notNull(Reflect.field(result.struct, "object"));
		Assert.equals(1, Reflect.fields(result.struct.object).length);
		Assert.equals(567, Reflect.field(Reflect.field(result.struct, "object"), "integer"));
	}

	public function testStrictChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:strictlyTyped>
					<tests:TestPropertiesClass
						boolean="true"
						float="123.4"
						integer="567"
						string="hello"
						canBeNull="890.1">
						<tests:struct>
							<mx:Struct float="123.4" boolean="true" string="hello">
								<mx:object>
									<mx:Struct>
										<mx:integer>567</mx:integer>
									</mx:Struct>
								</mx:object>
							</mx:Struct>
						</tests:struct>
					</tests:TestPropertiesClass>
				</tests:strictlyTyped>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.notNull(result.strictlyTyped);
		Assert.isTrue(result.strictlyTyped.boolean);
		Assert.equals(123.4, result.strictlyTyped.float);
		Assert.equals("hello", result.strictlyTyped.string);
		Assert.equals(567, result.strictlyTyped.integer);
		Assert.equals(890.1, result.strictlyTyped.canBeNull);
		Assert.notNull(result.strictlyTyped.struct);
		Assert.equals(4, Reflect.fields(result.strictlyTyped.struct).length);
		Assert.isTrue(Reflect.hasField(result.strictlyTyped.struct, "float"));
		Assert.isTrue(Reflect.hasField(result.strictlyTyped.struct, "boolean"));
		Assert.isTrue(Reflect.hasField(result.strictlyTyped.struct, "string"));
		Assert.isTrue(Reflect.hasField(result.strictlyTyped.struct, "object"));
		Assert.equals(123.4, Reflect.field(result.strictlyTyped.struct, "float"));
		Assert.isTrue(Reflect.field(result.strictlyTyped.struct, "boolean"));
		Assert.equals("hello", Reflect.field(result.strictlyTyped.struct, "string"));
		Assert.notNull(Reflect.field(result.strictlyTyped.struct, "object"));
		Assert.equals(567, Reflect.field(Reflect.field(result.strictlyTyped.struct, "object"), "integer"));
	}

	public function testArrayChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:array>
					<mx:String>one</mx:String>
					<mx:String>two</mx:String>
					<mx:String>three</mx:String>
				</tests:array>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(3, result.array.length);
		Assert.equals("one", result.array[0]);
		Assert.equals("two", result.array[1]);
		Assert.equals("three", result.array[2]);
	}

	public function testArrayChildElementRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:array>
					<mx:Array>
						<mx:String>one</mx:String>
						<mx:String>two</mx:String>
						<mx:String>three</mx:String>
					</mx:Array>
				</tests:array>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(3, result.array.length);
		Assert.equals("one", result.array[0]);
		Assert.equals("two", result.array[1]);
		Assert.equals("three", result.array[2]);
	}

	public function testArrayChildElementRedundantEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:array>
					<mx:Array></mx:Array>
				</tests:array>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(0, result.array.length);
	}

	public function testArrayChildElementRedundantEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:array>
					<mx:Array>
					</mx:Array>
				</tests:array>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(0, result.array.length);
	}

	public function testBoolTrueAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests"
				boolean="true"/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isTrue(result.boolean);
	}

	public function testBoolTrueAttributeExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests"
				boolean=" true "/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isTrue(result.boolean);
	}

	public function testBoolTrueChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:boolean>true</tests:boolean>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isTrue(result.boolean);
	}

	public function testBoolTrueChildElementExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:boolean>
					true
				</tests:boolean>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isTrue(result.boolean);
	}

	public function testBoolTrueChildElementComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:boolean>true<!-- comment --></tests:boolean>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isTrue(result.boolean);
	}

	public function testBoolTrueChildElementComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:boolean><!-- comment -->true</tests:boolean>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isTrue(result.boolean);
	}

	public function testBoolTrueChildElementComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:boolean>tr<!-- comment -->ue</tests:boolean>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isTrue(result.boolean);
	}

	public function testBoolTrueChildElementCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:boolean><![CDATA[true]]></tests:boolean>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isTrue(result.boolean);
	}

	public function testBoolTrueChildElementRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:boolean><mx:Bool>true</mx:Bool></tests:boolean>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isTrue(result.boolean);
	}

	public function testBoolChildElementRedundantEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:boolean><mx:Bool></mx:Bool></tests:boolean>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isFalse(result.boolean);
	}

	public function testBoolChildElementRedundantEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:boolean>
					<mx:Bool>
					</mx:Bool>
				</tests:boolean>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isFalse(result.boolean);
	}

	public function testClassAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests"
				type="fixtures.TestClass1"/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.type, Class);
		Assert.equals(fixtures.TestClass1, result.type);
	}

	public function testClassChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:type>fixtures.TestClass1</tests:type>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.type, Class);
		Assert.equals(fixtures.TestClass1, result.type);
	}

	public function testClassChildElementComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:type>fixtures.TestClass1<!-- comment --></tests:type>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.type, Class);
		Assert.equals(fixtures.TestClass1, result.type);
	}

	public function testClassChildElementComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:type><!-- comment -->fixtures.TestClass1</tests:type>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.type, Class);
		Assert.equals(fixtures.TestClass1, result.type);
	}

	public function testClassChildElementComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:type>fixtures.<!-- comment -->TestClass1</tests:type>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.type, Class);
		Assert.equals(fixtures.TestClass1, result.type);
	}

	public function testClassChildElementCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:type><![CDATA[fixtures.TestClass1]]></tests:type>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.type, Class);
		Assert.equals(fixtures.TestClass1, result.type);
	}

	public function testClassChildElementRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:type><mx:Class>fixtures.TestClass1</mx:Class></tests:type>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.type, Class);
		Assert.equals(fixtures.TestClass1, result.type);
	}

	public function testClassChildElementRedundantEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:type><mx:Class></mx:Class></tests:type>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isNull(result.type);
	}

	public function testClassChildElementRedundantEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:type>
					<mx:Class>
					</mx:Class>
				</tests:type>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isNull(result.type);
	}

	public function testAbstractEnumValueAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests"
				abstractEnumValue="Value2"/>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyAbstractEnum.Value2, result.abstractEnumValue);
	}

	public function testAbstractEnumValueChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:abstractEnumValue>Value2</tests:abstractEnumValue>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyAbstractEnum.Value2, result.abstractEnumValue);
	}

	public function testAbstractEnumValueChildElementComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:abstractEnumValue>Value2<!-- comment --></tests:abstractEnumValue>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyAbstractEnum.Value2, result.abstractEnumValue);
	}

	public function testAbstractEnumValueChildElementComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:abstractEnumValue><!-- comment -->Value2</tests:abstractEnumValue>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyAbstractEnum.Value2, result.abstractEnumValue);
	}

	public function testAbstractEnumValueChildElementComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:abstractEnumValue>Val<!-- comment -->ue2</tests:abstractEnumValue>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyAbstractEnum.Value2, result.abstractEnumValue);
	}

	public function testAbstractEnumValueChildElementCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:abstractEnumValue><![CDATA[Value2]]></tests:abstractEnumValue>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyAbstractEnum.Value2, result.abstractEnumValue);
	}

	public function testAbstractEnumValueChildElementRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:abstractEnumValue><tests:TestPropertyAbstractEnum>Value2</tests:TestPropertyAbstractEnum></tests:abstractEnumValue>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyAbstractEnum.Value2, result.abstractEnumValue);
	}

	public function testEnumValueAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests"
				enumValue="Value2"/>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyEnum.Value2, result.enumValue);
	}

	public function testEnumValueChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:enumValue>Value2</tests:enumValue>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyEnum.Value2, result.enumValue);
	}

	public function testEnumValueChildElementComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:enumValue>Value2<!-- comment --></tests:enumValue>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyEnum.Value2, result.enumValue);
	}

	public function testEnumValueChildElementComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:enumValue><!-- comment -->Value2</tests:enumValue>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyEnum.Value2, result.enumValue);
	}

	public function testEnumValueChildElementComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:enumValue>Val<!-- comment -->ue2</tests:enumValue>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyEnum.Value2, result.enumValue);
	}

	public function testEnumValueChildElementCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:enumValue><![CDATA[Value2]]></tests:enumValue>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyEnum.Value2, result.enumValue);
	}

	public function testEnumValueChildElementRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:enumValue><tests:TestPropertyEnum>Value2</tests:TestPropertyEnum></tests:enumValue>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyEnum.Value2, result.enumValue);
	}

	public function testComplexEnumValueChildElementWithoutParameters():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:complexEnum>
					<tests:TestComplexEnum.One/>
				</tests:complexEnum>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.equals(TestComplexEnum.One, result.complexEnum);
	}

	public function testComplexEnumValueChildElementWithParameters():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:complexEnum>
					<tests:TestComplexEnum.Two a="hello" b="123.4"/>
				</tests:complexEnum>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		switch (result.complexEnum) {
			case TestComplexEnum.Two("hello", 123.4):
				Assert.pass();
			default:
				Assert.fail("Wrong enum value: " + result.complexEnum);
		}
	}

	public function testComplexEnumValueChildElementWithoutParametersRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:complexEnum>
					<tests:TestComplexEnum>
						<tests:TestComplexEnum.One/>
					</tests:TestComplexEnum>
				</tests:complexEnum>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.equals(TestComplexEnum.One, result.complexEnum);
	}

	public function testComplexEnumValueChildElementWithParametersRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:complexEnum>
					<tests:TestComplexEnum>
						<tests:TestComplexEnum.Two a="hello" b="123.4"/>
					</tests:TestComplexEnum>
				</tests:complexEnum>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		switch (result.complexEnum) {
			case TestComplexEnum.Two("hello", 123.4):
				Assert.pass();
			default:
				Assert.fail("Wrong enum value: " + result.complexEnum);
		}
	}

	public function testERegAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests"
				ereg="~/[a-z]+/g">
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		#if eval
		Assert.equals("~/[a-z]+/g", Std.string(result.ereg));
		#end
	}

	public function testERegChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:ereg>~/[a-z]+/g</tests:ereg>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		#if eval
		Assert.equals("~/[a-z]+/g", Std.string(result.ereg));
		#end
	}

	public function testERegChildElementComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:ereg>~/[a-z]+/g<!-- comment --></tests:ereg>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		#if eval
		Assert.equals("~/[a-z]+/g", Std.string(result.ereg));
		#end
	}

	public function testERegChildElementComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:ereg>~<!-- comment -->/[a-z]+/g</tests:ereg>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		#if eval
		Assert.equals("~/[a-z]+/g", Std.string(result.ereg));
		#end
	}

	public function testERegChildElementCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:ereg><![CDATA[~/[a-z]+/g]]></tests:ereg>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		#if eval
		Assert.equals("~/[a-z]+/g", Std.string(result.ereg));
		#end
	}

	public function testERegChildElementRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:ereg><mx:EReg>~/[a-z]+/g</mx:EReg></tests:ereg>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		#if eval
		Assert.equals("~/[a-z]+/g", Std.string(result.ereg));
		#end
	}

	public function testERegChildElementRedundantEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:ereg><mx:EReg></mx:EReg></tests:ereg>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		#if eval
		Assert.equals("~//", Std.string(result.ereg));
		#end
	}

	public function testERegChildElementRedundantEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:ereg>
					<mx:EReg>
					</mx:EReg>
				</tests:ereg>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		#if eval
		Assert.equals("~//", Std.string(result.ereg));
		#end
	}

	public function testFloatAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests"
				float="123.4"/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testFloatAttributeExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests"
				float=" 123.4 "/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testFloatChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:float>123.4</tests:float>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testFloatChildElementExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:float>
					123.4
				</tests:float>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testFloatChildElementComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:float>123.4<!-- comment --></tests:float>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testFloatChildElementComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:float><!-- comment -->123.4</tests:float>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testFloatChildElementComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:float>12<!-- comment -->3.4</tests:float>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testFloatChildElementCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:float><![CDATA[123.4]]></tests:float>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testFloatChildElementRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:float><mx:Float>123.4</mx:Float></tests:float>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testFloatChildElementRedundantEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:float><mx:Float></mx:Float></tests:float>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.isTrue(Math.isNaN(result.float));
	}

	public function testFloatChildElementRedundantEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:float>
					<mx:Float>
					</mx:Float>
				</tests:float>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.isTrue(Math.isNaN(result.float));
	}

	public function testFloatChildElementNegative():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:float>-123.4</tests:float>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(-123.4, result.float);
	}

	public function testFloatChildElementHex():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:float>0xbeef</tests:float>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(0xbeef, result.float);
	}

	public function testFloatChildElementHexUpperCase():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:float>0xBEEF</tests:float>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(0xbeef, result.float);
	}

	public function testFloatChildElementHexMixedCase():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:float>0xbEeF</tests:float>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(0xbeef, result.float);
	}

	public function testFloatChildElementHexNegative():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:float>-0xbeef</tests:float>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(-0xbeef, result.float);
	}

	public function testIntAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests"
				integer="567"/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(567, result.integer);
	}

	public function testIntAttributeExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests"
				integer="567"/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(567, result.integer);
	}

	public function testIntAttributeHexLowerCase():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests"
				integer="0xbeef"/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(0xbeef, result.integer);
	}

	public function testIntAttributeHexLowerCaseNegative():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests"
				integer="-0xbeef"/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(-0xbeef, result.integer);
	}

	public function testIntAttributeHexUpperCase():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests"
				integer="0xBEEF"/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(0xbeef, result.integer);
	}

	public function testIntAttributeHexMixedCase():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests"
				integer="0xbEeF"/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(0xbeef, result.integer);
	}

	public function testIntAttributeHexUpperCaseNegative():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests"
				integer="-0xBEEF"/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(-0xbeef, result.integer);
	}

	public function testIntAttributeHexLowerCaseExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests"
				integer=" 0xbeef "/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(0xbeef, result.integer);
	}

	public function testIntChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:integer>567</tests:integer>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(567, result.integer);
	}

	public function testIntChildElementExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:integer>
					567
				</tests:integer>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(567, result.integer);
	}

	public function testIntChildElementComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:integer>567<!-- comment --></tests:integer>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(567, result.integer);
	}

	public function testIntChildElementComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:integer><!-- comment -->567</tests:integer>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(567, result.integer);
	}

	public function testIntChildElementComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:integer>56<!-- comment -->7</tests:integer>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(567, result.integer);
	}

	public function testIntChildElementCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:integer><![CDATA[567]]></tests:integer>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(567, result.integer);
	}

	public function testIntChildElementRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:integer><mx:Int>567</mx:Int></tests:integer>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(567, result.integer);
	}

	public function testIntChildElementRedundantEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:integer><mx:Int></mx:Int></tests:integer>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(0, result.integer);
	}

	public function testIntChildElementRedundantEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:integer>
					<mx:Int>
					</mx:Int>
				</tests:integer>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(0, result.integer);
	}

	public function testStringAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests"
				string="hello"/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("hello", result.string);
	}

	public function testStringAttributeEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests"
				string=""/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("", result.string);
	}

	public function testStringAttributeExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests"
				string=" hello "/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals(" hello ", result.string);
	}

	public function testStringChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:string>hello</tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("hello", result.string);
	}

	public function testStringChildElementExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:string> hello </tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals(" hello ", result.string);
	}

	public function testStringChildElementComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:string>hello<!-- comment --></tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("hello", result.string);
	}

	public function testStringChildElementComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:string><!-- comment -->hello</tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("hello", result.string);
	}

	public function testStringChildElementComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:string>hello<!-- comment -->world</tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("helloworld", result.string);
	}

	public function testStringChildElementEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:string></tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("", result.string);
	}

	public function testStringChildElementCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:string><![CDATA[MXHX & Haxe are <cool/>]]></tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("MXHX & Haxe are <cool/>", result.string);
	}

	public function testStringChildElementCDataEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:string><![CDATA[]]></tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("", result.string);
	}

	public function testStringChildElementCDataWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:string><![CDATA[ ]]></tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals(" ", result.string);
	}

	public function testStringChildElementCDataWhitespace2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:string><![CDATA[   ]]></tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("   ", result.string);
	}

	public function testStringChildElementCDataWhitespaceSurroundingWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:string>
					<![CDATA[   ]]>
				</tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("   ", result.string);
	}

	public function testStringChildElementCDataWhitespaceSurroundingWhitespace2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:string>
					<![CDATA[   ]]>
					<![CDATA[   ]]>
				</tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("      ", result.string);
	}

	public function testStringChildElementRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:string><mx:String>hello</mx:String></tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("hello", result.string);
	}

	public function testStringChildElementRedundantEmpty1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:string><mx:String></mx:String></tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		// child of field element: empty string, child of declarations: null
		Assert.equals("", result.string);
	}

	public function testStringChildElementRedundantEmpty2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:string><mx:String/></tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		// child of field element: empty string, child of declarations: null
		Assert.equals("", result.string);
	}

	public function testStringChildElementRedundantWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:string>
					<mx:String>
					</mx:String>
				</tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		// child of field element: empty string, child of declarations: null
		Assert.equals("", result.string);
	}

	public function testStringChildElementRedundantCDataEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:string><mx:String><![CDATA[]]></mx:String></tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		// child of field element: empty string, child of declarations: null
		Assert.equals("", result.string);
	}

	public function testStringChildElementRedundantCDataWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:string><mx:String><![CDATA[ ]]></mx:String></tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals(" ", result.string);
	}

	public function testStringChildElementRedundantCDataWhitespace2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:string><mx:String><![CDATA[   ]]></mx:String></tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("   ", result.string);
	}

	public function testStringChildElementRedundantCDataWhitespace3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:string><mx:String>
					<![CDATA[   ]]>
				</mx:String></tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("   ", result.string);
	}

	public function testStringChildElementRedundantCDataWhitespace4():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:string><mx:String>
					<![CDATA[   ]]>
					<![CDATA[   ]]>
				</mx:String></tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("      ", result.string);
	}

	public function testUIntAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests"
				unsignedInteger="0xFFFFFFFF"/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.unsignedInteger, Int);
		Assert.equals(0xFFFFFFFF, result.unsignedInteger);
	}

	public function testUIntAttributeExtraWhitespacee():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests"
				unsignedInteger=" 0xFFFFFFFF "/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.unsignedInteger, Int);
		Assert.equals(0xFFFFFFFF, result.unsignedInteger);
	}

	public function testUIntChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:unsignedInteger>0xFFFFFFFF</tests:unsignedInteger>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.unsignedInteger, Int);
		Assert.equals(0xFFFFFFFF, result.unsignedInteger);
	}

	public function testUIntChildElementExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:unsignedInteger>
					0xFFFFFFFF
				</tests:unsignedInteger>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.unsignedInteger, Int);
		Assert.equals(0xFFFFFFFF, result.unsignedInteger);
	}

	public function testUIntChildElementComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:unsignedInteger>0xFFFFFFFF<!-- comment --></tests:unsignedInteger>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.unsignedInteger, Int);
		Assert.equals(0xFFFFFFFF, result.unsignedInteger);
	}

	public function testUIntChildElementComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:unsignedInteger><!-- comment -->0xFFFFFFFF</tests:unsignedInteger>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.unsignedInteger, Int);
		Assert.equals(0xFFFFFFFF, result.unsignedInteger);
	}

	public function testUIntChildElementComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:unsignedInteger>0xFFFFF<!-- comment -->FFF</tests:unsignedInteger>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.unsignedInteger, Int);
		Assert.equals(0xFFFFFFFF, result.unsignedInteger);
	}

	public function testUIntChildElementCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:unsignedInteger><![CDATA[0xFFFFFFFF]]></tests:unsignedInteger>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.unsignedInteger, Int);
		Assert.equals(0xFFFFFFFF, result.unsignedInteger);
	}

	public function testUIntChildElementRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:unsignedInteger><mx:UInt>0xFFFFFFFF</mx:UInt></tests:unsignedInteger>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.unsignedInteger, Int);
		Assert.equals(0xFFFFFFFF, result.unsignedInteger);
	}

	public function testUIntChildElementRedundantEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:unsignedInteger><mx:UInt></mx:UInt></tests:unsignedInteger>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.unsignedInteger, Int);
		Assert.equals(0, result.unsignedInteger);
	}

	public function testUIntChildElementRedundantEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:unsignedInteger>
					<mx:UInt>
					</mx:UInt>
				</tests:unsignedInteger>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.unsignedInteger, Int);
		Assert.equals(0, result.unsignedInteger);
	}

	public function testDefaultPropertyClassWithSimpleValue():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestDefaultPropertyClass2
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				123.4
			</tests:TestDefaultPropertyClass2>
		');
		Assert.notNull(result);
		Assert.equals(123.4, result.float);
	}

	public function testDefaultPropertyClassWithSimpleValueRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestDefaultPropertyClass2
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Float>123.4</mx:Float>
			</tests:TestDefaultPropertyClass2>
		');
		Assert.notNull(result);
		Assert.equals(123.4, result.float);
	}

	public function testDefaultPropertyClassWithArrayValue():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestDefaultPropertyClass1
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:String>one</mx:String>
				<mx:String>two</mx:String>
				<mx:String>three</mx:String>
			</tests:TestDefaultPropertyClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.mxhxContent);
		var array = result.mxhxContent;
		Assert.equals(3, array.length);
		Assert.equals("one", array[0]);
		Assert.equals("two", array[1]);
		Assert.equals("three", array[2]);
	}

	public function testDefaultPropertyClassWithArrayValueRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestDefaultPropertyClass1
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Array>
					<mx:String>one</mx:String>
					<mx:String>two</mx:String>
					<mx:String>three</mx:String>
				</mx:Array>
			</tests:TestDefaultPropertyClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.mxhxContent);
		var array = result.mxhxContent;
		Assert.equals(3, array.length);
		Assert.equals("one", array[0]);
		Assert.equals("two", array[1]);
		Assert.equals("three", array[2]);
	}

	public function testDefaultPropertyClassWithArrayValueAndOtherPropertyBefore():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestDefaultPropertyClass1
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:other>four</tests:other>
				<mx:String>one</mx:String>
				<mx:String>two</mx:String>
				<mx:String>three</mx:String>
			</tests:TestDefaultPropertyClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.mxhxContent);
		var array = result.mxhxContent;
		Assert.equals(3, array.length);
		Assert.equals("one", array[0]);
		Assert.equals("two", array[1]);
		Assert.equals("three", array[2]);
		Assert.equals("four", result.other);
	}

	public function testDefaultPropertyClassWithArrayValueAndOtherPropertyAfter():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestDefaultPropertyClass1
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:String>one</mx:String>
				<mx:String>two</mx:String>
				<mx:String>three</mx:String>
				<tests:other>four</tests:other>
			</tests:TestDefaultPropertyClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.mxhxContent);
		var array = result.mxhxContent;
		Assert.equals(3, array.length);
		Assert.equals("one", array[0]);
		Assert.equals("two", array[1]);
		Assert.equals("three", array[2]);
		Assert.equals("four", result.other);
	}

	public function testDefaultPropertyClassWithArrayValueAndOtherPropertyBetween():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestDefaultPropertyClass1
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:String>one</mx:String>
				<tests:other>four</tests:other>
				<mx:String>two</mx:String>
				<mx:String>three</mx:String>
			</tests:TestDefaultPropertyClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.mxhxContent);
		var array = result.mxhxContent;
		Assert.equals(3, array.length);
		Assert.equals("one", array[0]);
		Assert.equals("two", array[1]);
		Assert.equals("three", array[2]);
		Assert.equals("four", result.other);
	}

	public function testCanBeNullChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:canBeNull>890.1</tests:canBeNull>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.canBeNull, Float);
		Assert.equals(890.1, result.canBeNull);
	}

	public function testCanBeNullChildElementComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:canBeNull>890.1<!-- comment --></tests:canBeNull>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.canBeNull, Float);
		Assert.equals(890.1, result.canBeNull);
	}

	public function testCanBeNullChildElementComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:canBeNull><!-- comment -->890.1</tests:canBeNull>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.canBeNull, Float);
		Assert.equals(890.1, result.canBeNull);
	}

	public function testCanBeNullChildElementComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:canBeNull>89<!-- comment -->0.1</tests:canBeNull>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.canBeNull, Float);
		Assert.equals(890.1, result.canBeNull);
	}

	public function testCanBeNullChildElementCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:canBeNull><![CDATA[890.1]]></tests:canBeNull>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.canBeNull, Float);
		Assert.equals(890.1, result.canBeNull);
	}

	public function testCanBeNullChildElementRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:canBeNull><mx:Float>890.1</mx:Float></tests:canBeNull>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.canBeNull, Float);
		Assert.equals(890.1, result.canBeNull);
	}

	public function testCanBeNullChildElementRedundantEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:canBeNull><mx:Float></mx:Float></tests:canBeNull>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.canBeNull, Float);
		Assert.isTrue(Math.isNaN(result.canBeNull));
	}

	public function testCanBeNullChildElementRedundantEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:canBeNull>
					<mx:Float>
					</mx:Float>
				</tests:canBeNull>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.canBeNull, Float);
		Assert.isTrue(Math.isNaN(result.canBeNull));
	}

	public function testXmlChildElementEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:xml>
					<mx:Xml></mx:Xml>
				</tests:xml>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstChild:Xml = xml.firstChild();
		Assert.notNull(firstChild);
		Assert.equals(XmlType.PCData, firstChild.nodeType);
		Assert.equals("", firstChild.nodeValue);
		Assert.isNull(xml.firstElement());
	}

	public function testDateChildElementNoFields():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:date>
					<mx:Date/>
				</tests:date>
			</tests:TestPropertiesClass>
		');
		var now = Date.now();
		Assert.notNull(result);
		Assert.isOfType(result.date, Date);
		var difference = now.getTime() - result.date.getTime();
		Assert.isTrue(difference < 1000.0);
	}

	public function testAbstractFrom():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:abstractFrom>123.4</tests:abstractFrom>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.equals(123.4, result.abstractFrom);
	}

	public function testAbstractFromModuleType():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:abstractFromModuleType>123.4</tests:abstractFromModuleType>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		var moduleType:ModuleType = result.abstractFromModuleType;
		Assert.equals(123.4, moduleType.value);
	}

	public function testClassFromModuleWithDifferentName():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:classFromModuleWithDifferentName>
					<tests:ThisClassHasADifferentNameThanItsModule prop="hello"/>
				</tests:classFromModuleWithDifferentName>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.notNull(result.classFromModuleWithDifferentName);
		Assert.equals("hello", result.classFromModuleWithDifferentName.prop);
	}

	public function testFunctionAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests"
				func="testMethod"/>
		');
		Assert.notNull(result);
		Assert.isTrue(Reflect.isFunction(result.func));
		Assert.isTrue(Reflect.compareMethods(result.testMethod, result.func));
	}

	public function testFunctionChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:func>testMethod</tests:func>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isTrue(Reflect.isFunction(result.func));
		Assert.isTrue(Reflect.compareMethods(result.testMethod, result.func));
	}

	public function testFunctionChildElementComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:func>testMethod<!-- comment --></tests:func>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isTrue(Reflect.isFunction(result.func));
		Assert.isTrue(Reflect.compareMethods(result.testMethod, result.func));
	}

	public function testFunctionChildElementComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:func><!-- comment -->testMethod</tests:func>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isTrue(Reflect.isFunction(result.func));
		Assert.isTrue(Reflect.compareMethods(result.testMethod, result.func));
	}

	public function testFunctionChildElementComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:func>test<!-- comment -->Method</tests:func>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isTrue(Reflect.isFunction(result.func));
		Assert.isTrue(Reflect.compareMethods(result.testMethod, result.func));
	}

	public function testFunctionChildElementCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:func><![CDATA[testMethod]]></tests:func>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isTrue(Reflect.isFunction(result.func));
		Assert.isTrue(Reflect.compareMethods(result.testMethod, result.func));
	}

	public function testFunctionChildElementRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:func><mx:Function>testMethod</mx:Function></tests:func>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isTrue(Reflect.isFunction(result.func));
		Assert.isTrue(Reflect.compareMethods(result.testMethod, result.func));
	}

	public function testFunctionChildElementRedundantEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:func><mx:Function></mx:Function></tests:func>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isNull(result.func);
	}

	public function testFunctionChildElementRedundantEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:func>
					<mx:Function>
					</mx:Function>
				</tests:func>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isNull(result.func);
	}

	public function testFunctionTypedAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests"
				funcTyped="testMethod"/>
		');
		Assert.notNull(result);
		Assert.isTrue(Reflect.isFunction(result.funcTyped));
		Assert.isTrue(Reflect.compareMethods(result.testMethod, result.funcTyped));
	}

	public function testFunctionTypedChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:funcTyped>testMethod</tests:funcTyped>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isTrue(Reflect.isFunction(result.funcTyped));
		Assert.isTrue(Reflect.compareMethods(result.testMethod, result.funcTyped));
	}
}
