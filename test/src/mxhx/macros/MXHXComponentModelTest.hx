package mxhx.macros;

import utest.Assert;
import utest.Test;

class MXHXComponentModelTest extends Test {
	public function testModelEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model"></mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(0, Reflect.fields(result.model).length);
	}

	public function testModelRootTagOnly1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root/>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(0, Reflect.fields(result.model).length);
	}

	public function testModelRootTagOnly2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root></root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(0, Reflect.fields(result.model).length);
	}

	public function testModelRootTagOnly3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(0, Reflect.fields(result.model).length);
	}

	public function testModelFloat():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>123.4</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Float);
		Assert.equals(123.4, result.model.child);
	}

	public function testModelFloatExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>
								123.4
							</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Float);
		Assert.equals(123.4, result.model.child);
	}

	public function testModelFloatCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child><![CDATA[123.4]]></child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Float);
		Assert.equals(123.4, result.model.child);
	}

	public function testModelFloatComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child><!-- comment -->123.4</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Float);
		Assert.equals(123.4, result.model.child);
	}

	public function testModelFloatComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>123.4<!-- comment --></child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Float);
		Assert.equals(123.4, result.model.child);
	}

	public function testModelFloatComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>123<!-- comment -->.4</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Float);
		Assert.equals(123.4, result.model.child);
	}

	public function testModelFloatExponent():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>123.4e5</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Float);
		Assert.equals(123.4e5, result.model.child);
	}

	public function testModelFloatNegativeExponent():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>123.4e-5</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Float);
		Assert.equals(123.4e-5, result.model.child);
	}

	public function testModelFloatNaN():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>NaN</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Float);
		Assert.isTrue(Math.isNaN(result.model.child));
	}

	public function testModelFloatInfinity():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>Infinity</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Float);
		Assert.equals(Math.POSITIVE_INFINITY, result.model.child);
	}

	public function testModelFloatNegativeInfinity():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>-Infinity</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Float);
		Assert.equals(Math.NEGATIVE_INFINITY, result.model.child);
	}

	public function testModelInt():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>567</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Int);
		Assert.equals(567, result.model.child);
	}

	public function testModelIntExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>
								567
							</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Int);
		Assert.equals(567, result.model.child);
	}

	public function testModelIntCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child><![CDATA[567]]></child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Int);
		Assert.equals(567, result.model.child);
	}

	public function testModelIntComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child><!-- comment -->567</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Int);
		Assert.equals(567, result.model.child);
	}

	public function testModelIntComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>567<!-- comment --></child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Int);
		Assert.equals(567, result.model.child);
	}

	public function testModelIntComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>5<!-- comment -->67</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Int);
		Assert.equals(567, result.model.child);
	}

	public function testModelIntHexLowerCase():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>0xbeef</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Int);
		Assert.equals(0xbeef, result.model.child);
	}

	public function testModelIntHexUpperCase():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>0xBEEF</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Int);
		Assert.equals(0xbeef, result.model.child);
	}

	public function testModelIntHexNegative():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>-0xbeef</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Int);
		Assert.equals(-0xbeef, result.model.child);
	}

	public function testModelBoolTrue():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>true</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Bool);
		Assert.isTrue(result.model.child);
	}

	public function testModelBoolTrueExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>
								true
							</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Bool);
		Assert.isTrue(result.model.child);
	}

	public function testModelBoolTrueCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child><![CDATA[true]]></child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Bool);
		Assert.isTrue(result.model.child);
	}

	public function testModelBoolTrueComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child><!-- comment -->true</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Bool);
		Assert.isTrue(result.model.child);
	}

	public function testModelBoolTrueComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>true<!-- comment --></child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Bool);
		Assert.isTrue(result.model.child);
	}

	public function testModelBoolTrueComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>tr<!-- comment -->ue</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Bool);
		Assert.isTrue(result.model.child);
	}

	public function testModelBoolFalse():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>false</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Bool);
		Assert.isFalse(result.model.child);
	}

	public function testModelBoolFalseExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>
								false
							</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Bool);
		Assert.isFalse(result.model.child);
	}

	public function testModelBoolFalseCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child><![CDATA[false]]></child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Bool);
		Assert.isFalse(result.model.child);
	}

	public function testModelBoolFalseComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child><!-- comment -->false</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Bool);
		Assert.isFalse(result.model.child);
	}

	public function testModelBoolFalseComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>false<!-- comment --></child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Bool);
		Assert.isFalse(result.model.child);
	}

	public function testModelBoolFalseComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>fa<!-- comment -->lse</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Bool);
		Assert.isFalse(result.model.child);
	}

	public function testModelString():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>hello</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, String);
		Assert.equals("hello", result.model.child);
	}

	public function testModelStringCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child><![CDATA[hello]]></child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, String);
		Assert.equals("hello", result.model.child);
	}

	public function testModelStringComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child><!-- comment -->hello</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, String);
		Assert.equals("hello", result.model.child);
	}

	public function testModelStringComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>hello<!-- comment --></child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, String);
		Assert.equals("hello", result.model.child);
	}

	public function testModelStringComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>he<!-- comment -->llo</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, String);
		Assert.equals("hello", result.model.child);
	}

	public function testModelSource():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model" source="source.xml"/>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Array);
		Assert.equals(3, result.model.child.length);
		Assert.equals("One", result.model.child[0]);
		Assert.equals("Two", result.model.child[1]);
		Assert.equals("Three", result.model.child[2]);
	}

	public function testModelSourceEmptyContent():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model" source="source.xml"></mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Array);
		Assert.equals(3, result.model.child.length);
		Assert.equals("One", result.model.child[0]);
		Assert.equals("Two", result.model.child[1]);
		Assert.equals("Three", result.model.child[2]);
	}

	public function testModelSourceEmptyContentExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model" source="source.xml">
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.model);
		Assert.equals(1, Reflect.fields(result.model).length);
		Assert.isOfType(result.model.child, Array);
		Assert.equals(3, result.model.child.length);
		Assert.equals("One", result.model.child[0]);
		Assert.equals("Two", result.model.child[1]);
		Assert.equals("Three", result.model.child[2]);
	}
}
