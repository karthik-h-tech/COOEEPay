class Plan {
  final String id; // 'free' | 'premium' | 'pro'
  final String name;
  final double price;
  final List<String> perks;

  const Plan({required this.id, required this.name, required this.price, required this.perks});
}

const List<Plan> plans = [
  Plan(id: 'free', name: 'Free', price: 0.0, perks: ['Basic calls', '100 mins/month', 'Community support']),
  Plan(id: 'premium', name: 'Premium', price: 9.99, perks: ['Unlimited calls', 'HD audio', 'Priority support']),
  Plan(id: 'pro', name: 'Pro', price: 19.99, perks: ['HD audio + video', 'Team features', 'Advanced controls']),
];
