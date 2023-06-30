import mxhx.macros.MXHXComponent;

class Main {
	public static function main():Void {
		var component = MXHXComponent.withMarkup('
			<example:TestClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:example="https://ns.example.com/mxhx">
				<mx:Declarations>
				</mx:Declarations>
				<example:component>
					<mx:Component>
						<example:TestClass testVarStr="hi"/>
					</mx:Component>
				</example:component>
			</example:TestClass>
		');

		trace(Type.createInstance(component.component, []));
		trace(Type.createInstance(component.component, []).testVarStr);
		trace(Type.createInstance(component.component, []).outerDocument);
		trace(mxhx._reserved.MXHXComponent_0);
		// trace(com.example.MyComponent);
	}
}
