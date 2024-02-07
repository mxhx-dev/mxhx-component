package mxhx.runtime;

import utest.Assert;
import utest.Test;

class MXHXRuntimeComponentObjectTest extends Test {
	public function testDeclarationsEmpty():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic">
				<mx:Declarations>
					<mx:String id="string">hello</mx:String>
				</mx:Declarations>
			</mx:Object>
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("string"));
		var string = idMap.get("string");
		Assert.equals("hello", string);
	}
}
