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

#if macro
import haxe.macro.Context;
import haxe.macro.Type;
import mxhx.resolver.IMXHXTypeSymbol;

/**
	Utility functions for MXHX macros.
**/
class MXHXMacroTools {
	public static function resolveTypeFromSymbol(typeSymbol:IMXHXTypeSymbol):Type {
		if (typeSymbol == null) {
			return null;
		}
		var type:Type = null;
		try {
			type = Context.getType(typeSymbol.qname);
		} catch (e:Dynamic) {
			return null;
		}
		switch (type) {
			case TInst(t, params):
				var resolvedParams = typeSymbol.params.map(paramTypeSymbol -> resolveTypeFromSymbol(paramTypeSymbol));
				return TInst(t, resolvedParams);
			case TEnum(t, params):
				var resolvedParams = typeSymbol.params.map(paramTypeSymbol -> resolveTypeFromSymbol(paramTypeSymbol));
				return TEnum(t, resolvedParams);
			case TAbstract(t, params):
				var resolvedParams = typeSymbol.params.map(paramTypeSymbol -> resolveTypeFromSymbol(paramTypeSymbol));
				return TAbstract(t, resolvedParams);
			default:
		}
		return null;
	}
}
#end
