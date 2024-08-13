package mxhx.macros;

import utest.Assert;
import utest.Test;

class MXHXComponentPrivateTest extends Test {
	public function testPrivateEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic">
				<mx:Private></mx:Private>
			</mx:Object>
		');
		Assert.notNull(result);
	}

	public function testPrivateXml():Void {
		var result = MXHXComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic">
				<mx:Private>
					<abc>123.4</abc>
				</mx:Private>
			</mx:Object>
		');
		Assert.notNull(result);
	}
}
