double applyDiscount(double price, double pct) => (price * (1 - pct)).clamp(0, double.infinity);
String money(double v) => v == 0 ? "\$0" : "\$${v.toStringAsFixed(2)}";
