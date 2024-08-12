/*
	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
 */

package mxhx.macros;

import mxhx.symbols.IMXHXSymbol;
import mxhx.resolver.IMXHXResolver;

@:dox(hide)
@:noCompletion
class MXHXComponentCompletion {
	private static final LANGUAGE_URI_BASIC_2024 = "https://ns.mxhx.dev/2024/basic";
	private static final LANGUAGE_URI_FULL_2024 = "https://ns.mxhx.dev/2024/mxhx";

	public static function isInsideTagPrefix(tagData:IMXHXTagData, offset:Int):Bool {
		// next, check that we're after the prefix
		// one extra for bracket
		var maxOffset = tagData.start + 1;
		var prefix = tagData.prefix;
		var prefixLength = prefix.length;
		if (prefixLength > 0) {
			// one extra for colon
			maxOffset += prefixLength + 1;
		}
		return offset > tagData.start && offset < maxOffset;
	}

	public static function getSymbolForMXHXNameAtOffset(tagData:IMXHXTagData, offset:Int, resolver:IMXHXResolver):IMXHXSymbol {
		if (tagData.isOffsetInAttributeList(offset)) {
			return getSymbolForMXHXTagAttribute(tagData, offset, false, resolver);
		}
		return resolver.resolveTag(tagData);
	}

	public static function getSymbolForMXHXTagAttribute(tagData:IMXHXTagData, offset:Int, includeValue:Bool, resolver:IMXHXResolver):IMXHXSymbol {
		var attributeData:IMXHXTagAttributeData = null;
		if (includeValue) {
			attributeData = getMXHXTagAttributeAtOffset(tagData, offset);
		} else {
			attributeData = getMXHXTagAttributeWithNameAtOffset(tagData, offset, false);
		}
		if (attributeData == null) {
			return null;
		}
		return resolver.resolveAttribute(attributeData);
	}

	public static function getMXHXTagAttributeAtOffset(tagData:IMXHXTagData, offset:Int):IMXHXTagAttributeData {
		for (attributeData in tagData.attributeData) {
			if (offset >= attributeData.start && offset <= attributeData.end) {
				return attributeData;
			}
		}
		return null;
	}

	public static function getMXHXTagAttributeWithNameAtOffset(tagData:IMXHXTagData, offset:Int, includeEnd:Bool):IMXHXTagAttributeData {
		for (attributeData in tagData.attributeData) {
			trace(attributeData, offset, attributeData.valueStart);
			if (offset >= attributeData.start) {
				if (includeEnd && offset <= attributeData.end) {
					return attributeData;
				} else if (attributeData.valueStart == -1 && offset <= attributeData.end) {
					return attributeData;
				} else if (offset < attributeData.valueStart) {
					return attributeData;
				}
			}
		}
		return null;
	}

	public static function getMXHXTagAttributeWithValueAtOffset(tagData:IMXHXTagData, offset:Int):IMXHXTagAttributeData {
		for (attributeData in tagData.attributeData) {
			if (offset >= attributeData.valueStart && offset <= attributeData.valueEnd) {
				return attributeData;
			}
		}
		return null;
	}

	public static function isLanguageUri(uri:String):Bool {
		return uri == LANGUAGE_URI_BASIC_2024 || uri == LANGUAGE_URI_FULL_2024;
	}

	public static function isDeclarationsTag(tagData:IMXHXTagData):Bool {
		if (tagData == null) {
			return false;
		}
		var shortName = tagData.shortName;
		if (shortName == null || shortName != "Declarations") {
			return false;
		}
		var uri = tagData.uri;
		if (uri == null || !isLanguageUri(uri)) {
			return false;
		}
		return true;
	}
}
