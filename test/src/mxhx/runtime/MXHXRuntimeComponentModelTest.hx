package mxhx.runtime;

import mxhx.runtime.MXHXRuntimeComponent.MXHXRuntimeComponentException;
import utest.Assert;
import utest.Test;

class MXHXRuntimeComponentModelTest extends Test {
	public function testModelEmpty():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model"></mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(0, Reflect.fields(model).length);
	}

	public function testModelTextContent():Void {
		Assert.raises(() -> MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">hello</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		'), MXHXRuntimeComponentException);
	}

	public function testModelRootTagOnly1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root/>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(0, Reflect.fields(model).length);
	}

	public function testModelRootTagOnly2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root></root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(0, Reflect.fields(model).length);
	}

	public function testModelRootTagOnly3():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(0, Reflect.fields(model).length);
	}

	public function testModelFloat():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>123.4</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Float);
		Assert.equals(123.4, child);
	}

	public function testModelFloatNegative():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>-123.4</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Float);
		Assert.equals(-123.4, child);
	}

	public function testModelFloatExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
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
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Float);
		Assert.equals(123.4, child);
	}

	public function testModelFloatCData():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child><![CDATA[123.4]]></child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Float);
		Assert.equals(123.4, child);
	}

	public function testModelFloatComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child><!-- comment -->123.4</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Float);
		Assert.equals(123.4, child);
	}

	public function testModelFloatComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>123.4<!-- comment --></child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Float);
		Assert.equals(123.4, child);
	}

	public function testModelFloatComment3():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>123<!-- comment -->.4</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Float);
		Assert.equals(123.4, child);
	}

	public function testModelFloatExponent():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>123.4e5</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Float);
		Assert.equals(123.4e5, child);
	}

	public function testModelFloatNegativeExponent():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>123.4e-5</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Float);
		Assert.equals(123.4e-5, child);
	}

	public function testModelFloatNaN():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>NaN</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Float);
		Assert.isTrue(Math.isNaN(child));
	}

	public function testModelFloatInfinity():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>Infinity</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Float);
		Assert.equals(Math.POSITIVE_INFINITY, child);
	}

	public function testModelFloatNegativeInfinity():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>-Infinity</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Float);
		Assert.equals(Math.NEGATIVE_INFINITY, child);
	}

	public function testModelInt():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>567</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Int);
		Assert.equals(567, child);
	}

	public function testModelIntNegative():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>-567</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Int);
		Assert.equals(-567, child);
	}

	public function testModelIntExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
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
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Int);
		Assert.equals(567, child);
	}

	public function testModelIntCData():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child><![CDATA[567]]></child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Int);
		Assert.equals(567, child);
	}

	public function testModelIntComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child><!-- comment -->567</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Int);
		Assert.equals(567, child);
	}

	public function testModelIntComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>567<!-- comment --></child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Int);
		Assert.equals(567, child);
	}

	public function testModelIntComment3():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>5<!-- comment -->67</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Int);
		Assert.equals(567, child);
	}

	public function testModelIntHexLowerCase():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>0xbeef</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Int);
		Assert.equals(0xbeef, child);
	}

	public function testModelIntHexUpperCase():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>0xBEEF</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Int);
		Assert.equals(0xbeef, child);
	}

	public function testModelIntHexMixedCase():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>0xbEeF</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Int);
		Assert.equals(0xbeef, child);
	}

	public function testModelIntHexNegative():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>-0xbeef</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Int);
		Assert.equals(-0xbeef, child);
	}

	public function testModelBoolTrue():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>true</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Bool);
		Assert.isTrue(child);
	}

	public function testModelBoolTrueExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
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
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Bool);
		Assert.isTrue(child);
	}

	public function testModelBoolTrueCData():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child><![CDATA[true]]></child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Bool);
		Assert.isTrue(child);
	}

	public function testModelBoolTrueComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child><!-- comment -->true</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Bool);
		Assert.isTrue(child);
	}

	public function testModelBoolTrueComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>true<!-- comment --></child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Bool);
		Assert.isTrue(child);
	}

	public function testModelBoolTrueComment3():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>tr<!-- comment -->ue</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Bool);
		Assert.isTrue(child);
	}

	public function testModelBoolFalse():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>false</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Bool);
		Assert.isFalse(child);
	}

	public function testModelBoolFalseExtraWhitespace():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
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
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Bool);
		Assert.isFalse(child);
	}

	public function testModelBoolFalseCData():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child><![CDATA[false]]></child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Bool);
		Assert.isFalse(child);
	}

	public function testModelBoolFalseComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child><!-- comment -->false</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Bool);
		Assert.isFalse(child);
	}

	public function testModelBoolFalseComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>false<!-- comment --></child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Bool);
		Assert.isFalse(child);
	}

	public function testModelBoolFalseComment3():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>fa<!-- comment -->lse</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, Bool);
		Assert.isFalse(child);
	}

	public function testModelString():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>hello</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, String);
		Assert.equals("hello", child);
	}

	public function testModelStringCData():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child><![CDATA[hello]]></child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, String);
		Assert.equals("hello", child);
	}

	public function testModelStringComment1():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child><!-- comment -->hello</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, String);
		Assert.equals("hello", child);
	}

	public function testModelStringComment2():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>hello<!-- comment --></child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, String);
		Assert.equals("hello", child);
	}

	public function testModelStringComment3():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model">
						<root>
							<child>he<!-- comment -->llo</child>
						</root>
					</mx:Model>
				</mx:Declarations>
			</tests:TestClass1>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("model"));
		var model = idMap.get("model");
		Assert.notNull(model);
		Assert.equals(1, Reflect.fields(model).length);
		var child = Reflect.field(model, "child");
		Assert.isOfType(child, String);
		Assert.equals("hello", child);
	}

	public function testModelSource():Void {
		Assert.raises(() -> MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Model id="model" source="source.xml"/>
				</mx:Declarations>
			</tests:TestClass1>
		'), MXHXRuntimeComponentException);
	}
}
