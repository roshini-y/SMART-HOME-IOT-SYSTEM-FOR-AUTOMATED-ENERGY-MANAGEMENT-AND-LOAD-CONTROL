class TariffCalculator {
  static double calculateDailyBudget(double maxBill) {
    // Telangana tariff slabs (2023)
    const slab1Rate = 1.45; // First 0-100 units
    const slab2Rate = 2.60; // 101-200 units
    const slab3Rate = 4.30; // Above 200 units

    // Calculate how many units we can afford within the max bill
    double maxUnits;
    double rate;

    if (maxBill <= 100 * slab1Rate) {
      // All units in first slab
      maxUnits = maxBill / slab1Rate;
      rate = slab1Rate;
    } else if (maxBill <= (100 * slab1Rate) + (100 * slab2Rate)) {
      // Some units in second slab
      final remainingBill = maxBill - (100 * slab1Rate);
      maxUnits = 100 + (remainingBill / slab2Rate);
      rate = (100 * slab1Rate + (maxUnits - 100) * slab2Rate) / maxUnits;
    } else {
      // Some units in third slab
      final remainingBill = maxBill - (100 * slab1Rate) - (100 * slab2Rate);
      maxUnits = 200 + (remainingBill / slab3Rate);
      rate =
          (100 * slab1Rate + 100 * slab2Rate + (maxUnits - 200) * slab3Rate) /
              maxUnits;
    }

    // Calculate days remaining in month
    final now = DateTime.now();
    final firstDayNextMonth = DateTime(now.year, now.month % 12 + 1, 1);
    final lastDayCurrentMonth =
        firstDayNextMonth.subtract(const Duration(days: 1));
    final daysInMonth = lastDayCurrentMonth.day;
    final daysRemaining = daysInMonth - now.day + 1;

    final dailyBudget = maxUnits / daysRemaining;
    return dailyBudget;
  }
}
