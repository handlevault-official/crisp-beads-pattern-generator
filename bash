#!/bin/bash

# Crisp Invoice Generator - Automated Setup Script
# Run this in your terminal to initialize the repo structure and files.

REPO_NAME="crisp-invoice-generator"
echo "[*] Initializing $REPO_NAME workspace..."

# Create project directory
mkdir -p "$REPO_NAME"
cd "$REPO_NAME" || exit

# Initialize git if not already initialized
if [ ! -d ".git" ]; then
    git init
    echo "[*] Initialized local Git repository."
fi

# Create index.html with the complete Invoice Generator code
cat << 'EOF' > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crisp Invoice Generator</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #0f172a; color: #f8fafc; padding: 20px; }
        .container { max-width: 900px; margin: 0 auto; background: #1e293b; padding: 30px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.5); border: 1px solid #334155; }
        header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #3b82f6; padding-bottom: 20px; margin-bottom: 25px; }
        h1 { color: #38bdf8; font-size: 24px; letter-spacing: 1px; }
        .grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px; }
        .input-group { display: flex; flexDirection: column; gap: 6px; margin-bottom: 12px; }
        label { font-size: 12px; text-transform: uppercase; color: #94a3b8; font-weight: bold; }
        input, textarea { background: #0f172a; border: 1px solid #334155; color: #fff; padding: 10px; border-radius: 6px; font-size: 14px; width: 100%; }
        input:focus, textarea:focus { outline: none; border-color: #38bdf8; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #334155; }
        th { color: #38bdf8; font-size: 13px; text-transform: uppercase; }
        .btn { background: #3b82f6; color: white; border: none; padding: 10px 18px; border-radius: 6px; font-weight: bold; cursor: pointer; transition: background 0.2s; }
        .btn:hover { background: #2563eb; }
        .btn-danger { background: #ef4444; padding: 6px 10px; }
        .btn-danger:hover { background: #dc2626; }
        .totals { text-align: right; margin-top: 20px; font-size: 18px; }
        .totals span { color: #22c55e; font-weight: bold; }
        @media print {
            body { background: #fff; color: #000; padding: 0; }
            .container { border: none; box-shadow: none; background: #fff; color: #000; max-width: 100%; }
            input, textarea { border: none; background: transparent; color: #000; padding: 0; }
            .btn, .no-print { display: none; }
            th { color: #000; border-bottom: 2px solid #000; }
            td { border-bottom: 1px solid #ccc; color: #000; }
            .totals span { color: #000; }
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <div>
                <h1>CRISP INVOICE GENERATOR</h1>
                <p style="font-size: 12px; color: #94a3b8;">Fast, Modern & Clean Business Billing</p>
            </div>
            <button class="btn no-print" onclick="window.print()">Print / Save PDF</button>
        </header>
        <div class="grid-2">
            <div>
                <div class="input-group"><label>Your Company / Name</label><input type="text" value="HandleVault Studios"></div>
                <div class="input-group"><label>Billed To (Client Name)</label><input type="text" placeholder="Client Name / Business"></div>
            </div>
            <div>
                <div class="input-group"><label>Invoice Number</label><input type="text" value="INV-001"></div>
                <div class="input-group"><label>Date</label><input type="date" id="invDate"></div>
            </div>
        </div>
        <table>
            <thead>
                <tr>
                    <th>Item Description</th>
                    <th style="width: 100px;">Qty</th>
                    <th style="width: 140px;">Price ($)</th>
                    <th style="width: 140px;">Total ($)</th>
                    <th class="no-print" style="width: 50px;"></th>
                </tr>
            </thead>
            <tbody id="itemsBody">
                <tr>
                    <td><input type="text" value="Pixel Art Asset Pack Design"></td>
                    <td><input type="number" class="qty" value="1" min="1" oninput="calculate()"></td>
                    <td><input type="number" class="price" value="150" min="0" oninput="calculate()"></td>
                    <td class="item-total">$150.00</td>
                    <td class="no-print"><button class="btn btn-danger" onclick="deleteRow(this)">X</button></td>
                </tr>
            </tbody>
        </table>
        <button class="btn no-print" onclick="addRow()">+ Add Item</button>
        <div class="totals">Total Amount Due: <span id="grandTotal">$150.00</span></div>
    </div>
    <script>
        document.getElementById('invDate').valueAsDate = new Date();
        function calculate() {
            const rows = document.querySelectorAll('#itemsBody tr');
            let total = 0;
            rows.forEach(row => {
                const qty = parseFloat(row.querySelector('.qty').value) || 0;
                const price = parseFloat(row.querySelector('.price').value) || 0;
                const itemTotal = qty * price;
                row.querySelector('.item-total').textContent = '$' + itemTotal.toFixed(2);
                total += itemTotal;
            });
            document.getElementById('grandTotal').textContent = '$' + total.toFixed(2);
        }
        function addRow() {
            const tbody = document.getElementById('itemsBody');
            const tr = document.createElement('tr');
            tr.innerHTML = `<td><input type="text" placeholder="Description"></td><td><input type="number" class="qty" value="1" min="1" oninput="calculate()"></td><td><input type="number" class="price" value="0" min="0" oninput="calculate()"></td><td class="item-total">$0.00</td><td class="no-print"><button class="btn btn-danger" onclick="deleteRow(this)">X</button></td>`;
            tbody.appendChild(tr);
            calculate();
        }
        function deleteRow(btn) {
            btn.closest('tr').remove();
            calculate();
        }
    </script>
</body>
</html>
EOF

echo "[*] Successfully generated index.html for $REPO_NAME!"
echo "[*] Run 'git add index.html' and 'git commit -m \"Initial commit\"' to push to GitHub."
