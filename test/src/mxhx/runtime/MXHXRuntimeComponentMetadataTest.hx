package mxhx.runtime;

import utest.Assert;
import utest.Test;

class MXHXRuntimeComponentMetadataTest extends Test {
	public function testMetadataEmpty():Void {
		Assert.raises(() -> MXHXRuntimeComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic">
				<mx:Metadata></mx:Metadata>
			</mx:Object>
		'), haxe.Exception);
	}
}
