export function formatMoney(value) {
  const number = Number(value);

  if (isNaN(number)) return "0";

  return number.toLocaleString("en-US", {
    maximumFractionDigits: 20,
  });
}
