package mxhx.resolver;

class MXHXSymbolTools {
	public static function resolveFieldByName(classSymbol:IMXHXClassSymbol, fieldName:String):IMXHXFieldSymbol {
		var current = classSymbol;
		while (current != null) {
			var resolved = Lambda.find(current.fields, field -> field.name == fieldName);
			if (resolved != null) {
				return resolved;
			}
			current = current.superClass;
		}
		return null;
	}

	public static function resolveEventByName(classSymbol:IMXHXClassSymbol, eventName:String):IMXHXEventSymbol {
		var current = classSymbol;
		while (current != null) {
			var resolved = Lambda.find(current.events, event -> event.name == eventName);
			if (resolved != null) {
				return resolved;
			}
			current = current.superClass;
		}
		return null;
	}

	public static function getUnifiedType(t1:IMXHXTypeSymbol, t2:IMXHXTypeSymbol):IMXHXTypeSymbol {
		if (t1 == null) {
			return t2;
		} else if (t2 == null) {
			return t1;
		}
		var current1 = t1;
		while (current1 != null) {
			var current2 = t2;
			while (current2 != null) {
				if (current2.qname == current1.qname) {
					return current1;
				}
				if ((current2 is IMXHXClassSymbol)) {
					var class2:IMXHXClassSymbol = cast current2;
					current2 = class2.superClass;
				} else {
					current2 = null;
				}
			}
			if ((current1 is IMXHXClassSymbol)) {
				var class1:IMXHXClassSymbol = cast current1;
				current1 = class1.superClass;
			} else {
				current1 = null;
			}
		}
		return null;
	}
}
