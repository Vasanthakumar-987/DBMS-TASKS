"""Run this folder's SQL in SQLite 3.39+ and regenerate outputs.md.
MySQL CREATE DATABASE and USE are skipped; every other statement is executed.
Usage: python verify.py
"""
from pathlib import Path
import sqlite3, re, json, html

folder = Path(__file__).resolve().parent
sql = next(folder.glob('*.sql')).read_text()
assert sqlite3.sqlite_version_info >= (3,39,0), 'SQLite 3.39+ required for RIGHT JOIN'
setup, queries = sql.split('-- QUERY SECTION', 1)
setup = re.sub(r'^(CREATE DATABASE|USE) .*?;\s*$', '', setup, flags=re.M)
db = sqlite3.connect(':memory:')
db.execute('PRAGMA foreign_keys = ON')
db.executescript(setup)
results=[]
for number, title, statement in re.findall(r'-- Q(\d+): ([^\n]+)\n(.*?)(?=\n-- Q\d+:|\Z)',queries,re.S):
    cur=db.execute(statement.strip())
    results.append(dict(number=int(number), title=title, sql=statement.strip(), columns=[c[0] for c in cur.description], rows=cur.fetchall()))
assert db.execute('PRAGMA foreign_key_check').fetchall()==[]
assert db.execute('SELECT o.order_id FROM Orders o JOIN Order_Details d ON o.order_id=d.order_id GROUP BY o.order_id,o.total_amount HAVING o.total_amount <> SUM(d.quantity*d.unit_price)').fetchall()==[]
assert db.execute("SELECT o.order_id FROM Orders o JOIN Payment p ON o.order_id=p.order_id WHERE p.payment_status='SUCCESS' AND p.amount <> o.total_amount").fetchall()==[]
if folder.name=='Task8':
    assert len(results)==8
    assert len(results[0]['rows'])==8
    assert results[1]['rows'][-1]==(4,'Divya',None,None)
    assert results[2]['rows'][4]==(1005,999,None,None,None)
    assert len(results[3]['rows'])==9
    assert len(results[4]['rows'])==3
    assert sum(r[-1] for r in results[5]['rows'])==8492
    assert sum(r[-1] for r in results[6]['rows'])==8492
    assert [r[0] for r in results[7]['rows']]==[1005,1006]
else:
    assert len(results)==6
    assert results[0]['rows']==[(4,8492,2123.0,1299,3298)]
    assert results[2]['rows'][0]==(2,'Priya',1,3298)
    assert results[3]['rows'][0]==(107,'DBMS Fundamentals',2,1300)
    assert results[4]['rows'][-1]==('Home Appliances',0,0)
    assert all(sum(r[-1] for r in results[i]['rows'])==8492 for i in [1,2,3,4,5])

out=[f'# {folder.name} — Executed Query Outputs',f'Engine: SQLite {sqlite3.sqlite_version}. MySQL CREATE DATABASE and USE were skipped; all queries, including RIGHT JOIN, ran as written. NULL means no matching record. Amounts are in INR. These are actual execution results, not MySQL Workbench captures.']
for r in results:
    out += [f"## Q{r['number']}: {r['title']}", '```sql\n'+r['sql']+'\n```', '| '+' | '.join(r['columns'])+' |', '| '+' | '.join(['---']*len(r['columns']))+' |']
    out += ['| '+' | '.join('NULL' if x is None else str(x) for x in row)+' |' for row in r['rows']]
    out += [f"{len(r['rows'])} rows returned.\n"]
(folder/'outputs.md').write_text('\n\n'.join(out).replace(' |\n\n|',' |\n|'))
# JSON is a temporary input for the screenshot renderer.
(folder/'_results.json').write_text(json.dumps(results,indent=2))
print(folder.name, ':',len(results),'queries executed; totals, keys and edge cases verified.')
