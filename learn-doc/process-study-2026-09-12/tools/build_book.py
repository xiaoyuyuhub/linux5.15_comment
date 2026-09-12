#!/usr/bin/env python3
"""仅依赖 Python 标准库。生成源码摘录、离线 SVG、单文件学习网页。"""
from pathlib import Path
import re, html, hashlib, json, subprocess
ROOT=Path(__file__).resolve().parents[1]
REPO=ROOT.parent
D=ROOT/'diagrams'
D.mkdir(exist_ok=True)
def esc(x): return html.escape(str(x),quote=True)
def svg_start(title,w=1120,h=850):
    return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" role="img" aria-label="{esc(title)}"><defs><marker id="a" markerWidth="9" markerHeight="9" refX="8" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8" fill="none" stroke="#35758b" stroke-width="1.6"/></marker></defs><rect width="{w}" height="{h}" rx="20" fill="#f5f8fb"/><style>text{{font-family:system-ui,'PingFang SC','Microsoft YaHei',sans-serif;fill:#18384b}}.title{{font-size:28px;font-weight:700}}.label{{font-size:20px;font-weight:650}}.small{{font-size:17px}}.edge{{stroke:#35758b;stroke-width:2;fill:none;marker-end:url(#a)}}</style><text class="title" x="36" y="47">{esc(title)}</text>'''
def node(x,y,w,lines,fill='#e0eef3',h=74):
    s=f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="12" fill="{fill}" stroke="#a9c7d1"/>'
    for i,t in enumerate(lines): s+=f'<text x="{x+18}" y="{y+29+i*25}" class="{"label" if i==0 else "small"}">{esc(t)}</text>'
    return s
def arrow(x1,y1,x2,y2): return f'<path class="edge" d="M{x1},{y1} L{x2},{y2}"/>'
def flow(filename,title,steps):
    h=110+len(steps)*113
    s=svg_start(title,h=h)
    for i,(a,b,c) in enumerate(steps):
        y=85+i*113
        s+=node(35,y,535,[a,b])
        s+=f'<text class="small" x="602" y="{y+32}">{esc(c)}</text>'
        if i<len(steps)-1:s+=arrow(302,y+75,302,y+110)
    (D/filename).write_text(s+'</svg>')
flow('lifecycle.svg','从启动静态任务到用户进程回收',[
('init_task · PID 0','静态对象、内核栈、init_mm','起点不是 fork：对象在编译链接时存在'),
('start_kernel → rest_init','调度 / PID / 对象缓存已准备','PID 0 分别创建 PID 1 与 PID 2'),
('PID 1: kernel_init → kernel_execve','从内核启动任务进入用户 init','PID 2 kthreadd 处理另一条内核线程分支'),
('shell → fork / clone','创建 task、资源、初始执行现场','wake_up_new_task 让孩子可运行'),
('子任务 → execve → 新应用','新 mm、ELF 映射、用户入口','普通单线程情形下进程 PID 保留'),
('运行 ↔ 等待 ↔ 唤醒','rq 选择；页表 / 内核栈切换','内存访问可触发缺页 / COW'),
('do_exit → zombie → wait','先释放使用资源，再收集退出状态','最后引用和 RCU 决定结构最终释放')])
flow('boot.svg','0 / 1 / 2 号任务：创建顺序与同步',[
('PID 0: rest_init','kernel_thread(kernel_init, NULL, CLONE_FS)','创建 PID 1；它可能已被调度'),
('PID 1: kernel_init','wait_for_completion(kthreadd_done)','未完成时睡眠，不推进依赖初始化'),
('PID 0: 创建 kthreadd','记录 kthreadd_task（PID 2）','这是创建分叉，不是 PID 1 调用 PID 2'),
('PID 0: complete(kthreadd_done)','进入 schedule / idle','允许 PID 1 继续，不等 PID 2 执行结束'),
('PID 1: kernel_init_freeable','SMP / initcalls / rootfs 等','完成初始化、回收 init 内存'),
('PID 1: kernel_execve','安装用户 mm 和寄存器入口','ret_from_fork 衔接返回用户态')])
flow('fork.svg','copy_process：构造、发布、初次唤醒',[
('校验 flags / namespace / 信号','不合法组合尽早返回错误','CLONE_THREAD → SIGHAND → VM'),
('dup_task_struct','新 task + 独立内核栈','复制父模板之后，逐项重建私有状态'),
('计数 / 凭据 / sched_fork','限制、锁、统计、TASK_NEW','初始化期间不允许普通运行'),
('copy_* 资源 + copy_thread','复制或共享，构造初始内核栈框架','失败从 bad_fork_* 逆序释放已得资源'),
('分配 PID / 建立组和父关系','锁保护下让新任务可见','可见不等于此时已经执行用户代码'),
('返回 kernel_clone','记录 fork 事件、取得 PID 引用','唤醒后孩子可能很快退出'),
('wake_up_new_task','TASK_RUNNING → 入队 → 判断抢占','未来调度到 ret_from_fork')])
flow('states.svg','状态机：用同一 TASK_RUNNING 表示就绪与运行',[
('TASK_NEW','创建中，还未首次唤醒','wake_up_new_task 进入下一阶段'),
('TASK_RUNNING：就绪 / 在 CPU 上运行','rq->curr / on_cpu 帮助判断实际执行者','被抢占时可仍保持 TASK_RUNNING'),
('条件不满足：设置睡眠状态并等待','例如空 pipe read、completion、wait','在正确同步协议下重查条件'),
('schedule：退出本轮 CPU 竞争','别的任务成为 current','等待者的内核栈保留续接位置'),
('事件发生 → try_to_wake_up','恢复可运行，等待调度选中','唤醒不是立即完成 read'),
('再次运行 → 重查条件 → 继续','随后也可能再次等待或退出','EXIT_ZOMBIE 是退出状态，非可运行态')])
flow('exit.svg','退出和回收是两位执行者的工作',[
('孩子：do_exit','组退出处理、标记退出中','不会再正常返回原用户程序'),
('孩子：exit_mm / files / fs 等','放下本任务持有的资源引用','共享 mm 尚有使用者则不会整体拆掉'),
('孩子：exit_notify','通知父、重定父关系、决定 autoreap','普通可等待孩子可能保留 EXIT_ZOMBIE'),
('孩子：do_task_dead → __schedule','离开自身内核栈','后继任务做调度尾部释放'),
('父：do_wait → wait_task_zombie','读取退出码与统计','WNOWAIT 可先观察而不回收'),
('父/回收者：release_task','脱离任务身份与关系','最后引用 / RCU 完成才最终释放存储')])
# 关系图：双 task 和共享资源。
s=svg_start('task 是执行实体；资源通过指针组织',h=640)
s+=node(35,120,300,['task A · pid 300','tgid 300 / 独立内核栈'])
s+=node(35,310,300,['task B · pid 301','tgid 300 / 独立内核栈'])
for y,ls in [(100,['同一 mm_struct','VMA → 页表 → 用户物理页']),(260,['共享资源对象','files / fs / signal / sighand']),(420,['独立执行现场','thread.sp / pt_regs / 调度实体'])]:s+=node(650,y,420,ls)
s+=arrow(335,155,650,140)+arrow(335,345,650,140)+arrow(335,160,650,295)+arrow(335,350,650,295)
s+=f'<text class="small" x="38" y="535">图示典型 pthread：普通 fork 会建立独立 mm；files 表也可独立但仍引用同一 struct file。</text>'
s+='<text class="small" x="38" y="574">共享的是资源对象；两个 task 的内核栈、TID、调度状态仍各自独立。</text>'
(D/'resources.svg').write_text(s+'</svg>')
s=svg_start('COW：虚拟地址相同，页表独立，数据页按需分开',h=730)
s+=node(35,100,410,['fork 后父：mm A → PTE A','VA X / 只读 → 物理页 P'])+node(35,220,410,['fork 后子：mm B → PTE B','VA X / 只读 → 物理页 P'])
s+=node(745,160,330,['物理页 P','原始内容：P'],h=100)
s+=arrow(445,135,745,185)+arrow(445,255,745,225)
s+='<text class="label" x="40" y="365">孩子写入 X → 写保护异常 → 需要复制时 wp_page_copy</text>'
s+=node(35,425,410,['父：PTE A 保留','VA X → 物理页 P'])+node(35,550,410,['子：PTE B 更新并允许写','VA X → 物理页 Q'])
s+=node(745,425,330,['物理页 P','父仍读到 P'])+node(745,550,330,['物理页 Q','复制后孩子写成 C'])
s+=arrow(445,462,745,462)+arrow(445,587,745,587)
s+='<text class="small" x="38" y="685">本图限定典型私有匿名页复制分支；独占页可复用，MAP_SHARED / 大页另有路径。</text>'
(D/'cow.svg').write_text(s+'</svg>')
s=svg_start('上下文切换：先协调地址空间，再交接内核栈',h=740)
s+=node(30,95,470,['轨道一：地址空间','context_switch → 根据 next->mm 分支'])+node(605,95,470,['轨道二：执行现场','switch_to → __switch_to_asm'])
s+=node(30,235,470,['next 有用户 mm','switch_mm_irqs_off / 同 mm 优化'])+node(605,235,470,['保存 prev 的 RSP','prev->thread.sp = 当前内核栈位置'])
s+=node(30,375,470,['next 无用户 mm','借用 / 转交 prev->active_mm'])+node(605,375,470,['装入 next 的 RSP','以后 pop / 返回读取 next 的栈'])
s+=node(320,560,500,['finish_task_switch / 新任务 schedule_tail','处理锁、旧借用 mm、死任务的相关引用'])
s+=arrow(265,170,265,232)+arrow(840,170,840,232)+arrow(840,310,840,372)+arrow(265,450,470,556)+arrow(840,450,670,556)
s+='<text class="small" x="35" y="697">左侧两个框是条件分支，不是先后都执行；右侧保存和装入则有严格顺序。</text>'
(D/'switch.svg').write_text(s+'</svg>')
# 真正时序图。
s=svg_start('shell → fork → exec → 等待回收：跨任务时序',h=800)
xs=[120,395,680,965]
for x,t in zip(xs,['父 shell','创建/调度机制','子 task','ELF / 退出回收']):
    s+=node(x-105,80,210,[t],h=55)
    s+=f'<path d="M{x},140 L{x},745" stroke="#acbdc6" stroke-dasharray="5 6"/>'
msgs=[(0,1,190,'fork / clone'),(1,2,255,'建立 task + 初始现场'),(1,0,320,'父返回 child PID'),(1,2,385,'调度后子返回 0'),(2,3,450,'exec：安装新映像'),(0,1,515,'wait：必要时睡眠'),(2,3,580,'do_exit：放下资源'),(3,0,645,'通知父 / 可收集状态'),(0,3,710,'wait 收集 → release_task')]
for a,b,y,t in msgs:
    s+=arrow(xs[a],y,xs[b],y)
    s+=f'<text class="small" text-anchor="middle" x="{(xs[a]+xs[b])/2}" y="{y-12}">{esc(t)}</text>'
s+='<text class="small" x="36" y="782">父返回与子首次执行的先后不固定；图只展示一种可能排布。</text>'
(D/'exec.svg').write_text(s+'</svg>')

# 从当前源码提取函数，保留原始文本；不把伪代码伪装成原码。
spec={
'init/init_task.c':['@file'],
'mm/init-mm.c':['@file'],
'init/main.c':['rest_init','kernel_init','kernel_init_freeable','run_init_process'],
'kernel/fork.c':['fork_init','proc_caches_init','dup_task_struct','copy_mm','dup_mm','dup_mmap','copy_files','copy_fs','copy_sighand','copy_signal','copy_process','kernel_clone','kernel_thread','mm_release'],
'arch/x86/kernel/process.c':['copy_thread'],
'kernel/sched/core.c':['sched_fork','wake_up_new_task','context_switch','__schedule','finish_task_switch','schedule_tail','try_to_wake_up'],
'kernel/sched/fair.c':['update_curr','check_preempt_tick','task_tick_fair','pick_next_task_fair'],
'fs/exec.c':['exec_mmap','begin_new_exec','do_execveat_common','kernel_execve','bprm_execve','exec_binprm'],
'fs/binfmt_elf.c':['load_elf_binary','create_elf_tables'],
'mm/memory.c':['copy_present_pte','copy_page_range','do_wp_page','wp_page_copy'],
'kernel/kthread.c':['kthreadd','create_kthread','kthread','__kthread_create_on_node'],
'kernel/exit.c':['do_exit','exit_mm','exit_notify','release_task','wait_task_zombie','do_wait'],
'arch/x86/entry/entry_64.S':['@asm:__switch_to_asm','@asm:ret_from_fork'],
}
def mask_c(src):
    return re.sub(r'/\*.*?\*/|//[^\n]*|"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'',lambda m: re.sub(r'[^\n]',' ',m.group()),src,flags=re.S)
def span_function(src,name):
    masked=mask_c(src)
    for m in re.finditer(r'\b'+re.escape(name)+r'\s*\(',masked):
        p=masked.index('(',m.start()); depth=1; end=p+1
        while end<len(masked) and depth:
            if masked[end]=='(':depth+=1
            elif masked[end]==')':depth-=1
            end+=1
        tail=re.match(r'\s*(?:__releases\s*\([^)]*\)\s*)?\{',masked[end:])
        if not tail:continue
        brace=end+tail.end()-1; depth=1; last=brace+1
        while last<len(masked) and depth:
            if masked[last]=='{':depth+=1
            elif masked[last]=='}':depth-=1
            last+=1
        start=src.rfind('\n',0,m.start())+1
        # 函数名独占行时保留上一行的返回类型/限定符。
        for _ in range(3):
            if start==0:break
            prev_start=src.rfind('\n',0,start-1)+1
            prev=src[prev_start:start].strip()
            if prev and not any(x in prev for x in [';','{','}','/*','*/']) and (prev.startswith(('static ','struct ','unsigned ','void ','int ','pid_t ')) or prev in ['static inline int','static inline void','static __always_inline struct rq *']):start=prev_start
            else:break
        return start,last
    raise ValueError('找不到函数定义: '+name)
records=[]
appendix=['# 17 当前源码原文摘录与定位\n','本章由 tools/build_book.py 从当前工作树直接抽取。下列原文没有根据讲解重写；文件中的既有中文注释仍可能有简化，以实际语句为准。每段标题给出原文件、函数与行号。选取的是主线关键函数，非整个 Linux 源码穷尽清单。\n','较长函数在网页中默认折叠；先按正文的阶段划分读，再打开全文。函数内含全部错误分支与条件编译，便于查看局部细节在全貌中的位置。\n']
for path,names in spec.items():
    src=(REPO/path).read_text(); digest=hashlib.sha256(src.encode()).hexdigest()
    for name in names:
        if name=='@file':a,b=0,len(src); label='完整文件'
        elif name.startswith('@asm:'):
            label=name.split(':')[1]
            m=re.search(r'^SYM_(?:FUNC|CODE)_START\('+label+r'\)',src,re.M); a=m.start()
            e=re.search(r'^SYM_(?:FUNC|CODE)_END\('+label+r'\)',src[a:],re.M);b=a+e.end()
        else:a,b=span_function(src,name);label=name
        first=src.count('\n',0,a)+1;last=src.count('\n',0,b)+1
        excerpt=src[a:b].rstrip()
        records.append(dict(file=path,symbol=label,line_start=first,line_end=last,sha256=digest))
        appendix += [f'## {path} · {label}\n',f'原文位置：`{path}:{first}–{last}`。 [打开仓库原文件](../../{path})\n', '```'+('asm' if path.endswith('.S') else 'c')+'\n'+excerpt+'\n```\n']
(ROOT/'chapters/17-关键源码原文.md').write_text('\n'.join(appendix))
(ROOT/'evidence/source-index.json').write_text(json.dumps(records,ensure_ascii=False,indent=2)+'\n')

# 受控 Markdown 子集：标题、段落、表格、列表、代码、链接和图片。
def inline(t):
    tokens=[]
    def hold(s):tokens.append(s);return f'@@TOKEN{len(tokens)-1}@@'
    t=re.sub(r'`([^`]+)`',lambda m:hold(('<a href="#src-'+esc(m[1])+'"><code>'+esc(m[1])+'</code></a>') if m[1] in {r['symbol'] for r in records if r['symbol']!='完整文件'} else '<code>'+esc(m[1])+'</code>'),t)
    t=re.sub(r'!\[([^]]*)\]\(([^)]+)\)',lambda m:hold(img(m[1],m[2])),t)
    t=re.sub(r'\[([^]]*)\]\(([^)]+)\)',lambda m:hold(link(m[1],m[2])),t)
    t=esc(t)
    t=re.sub(r'\*\*(.+?)\*\*',r'<strong>\1</strong>',t)
    for i,v in enumerate(tokens):t=t.replace(f'@@TOKEN{i}@@',v)
    return t
chapter_files=sorted((ROOT/'chapters').glob('*.md'))
chapter_map={p.name:'ch'+p.name[:2] for p in chapter_files}
def link(label,url):
    name=url.split('/')[-1]
    if name in chapter_map:url='#'+chapter_map[name]
    elif url.startswith('../../'):url='../'+url[6:]
    elif url.startswith('../'):url=url[3:]
    return f'<a href="{esc(url)}">{esc(label)}</a>'
def img(alt,url):
    p=(ROOT/'chapters'/url).resolve()
    if p.suffix=='.svg' and p.is_file():return '<figure>'+p.read_text()+f'<figcaption>{esc(alt)} · <a href="diagrams/{esc(p.name)}" target="_blank">放大查看</a></figcaption></figure>'
    return f'<img alt="{esc(alt)}" src="{esc(url)}">'
def render(src,is_source=False):
    ls=src.splitlines();out=[];i=0
    while i<len(ls):
        l=ls[i]
        if not l.strip():i+=1;continue
        if l.startswith('```'):
            lang=l[3:].strip();i+=1;buf=[]
            while i<len(ls) and not ls[i].startswith('```'):buf.append(ls[i]);i+=1
            i+=1
            block='<div class="codebox"><button class="copy" type="button">复制</button><pre><code>'+esc('\n'.join(buf))+'</code></pre></div>'
            if is_source:block='<details><summary>展开原始源码 · '+str(len(buf))+' 行</summary>'+block+'</details>'
            out.append(block);continue
        m=re.match(r'^(#{1,6}) (.+)',l)
        if m:
            level=min(len(m[1])+1,6)
            anchor=' id="src-'+esc(m[2].split(' · ')[-1])+'"' if is_source and ' · ' in m[2] and not m[2].endswith('完整文件') else ''
            out.append(f'<h{level}'+anchor+'>'+inline(m[2])+f'</h{level}>');i+=1;continue
        if l.startswith('|') and i+1<len(ls) and re.match(r'^\|[\s:|\-]+\|$',ls[i+1]):
            headers=[x.strip() for x in l.strip('|').split('|')];i+=2
            table='<div class="tablewrap"><table><thead><tr>'+''.join('<th>'+inline(x)+'</th>' for x in headers)+'</tr></thead><tbody>'
            while i<len(ls) and ls[i].startswith('|'):
                cells=[x.strip() for x in ls[i].strip('|').split('|')]
                table+='<tr>'+''.join('<td>'+inline(x)+'</td>' for x in cells)+'</tr>';i+=1
            out.append(table+'</tbody></table></div>');continue
        if re.match(r'^(\d+\. |[-*] )',l):
            ordered=bool(re.match(r'^\d+\.',l));tag='ol' if ordered else 'ul';items=[]
            while i<len(ls) and re.match(r'^(\d+\. |[-*] )',ls[i]):
                items.append('<li>'+inline(re.sub(r'^(\d+\. |[-*] )','',ls[i]))+'</li>');i+=1
            out.append('<'+tag+'>'+''.join(items)+'</'+tag+'>');continue
        if l.startswith('!['):out.append(inline(l));i+=1;continue
        buf=[l];i+=1
        while i<len(ls) and ls[i].strip() and not re.match(r'^(#|```|\||!\[|\d+\. |[-*] )',ls[i]):buf.append(ls[i]);i+=1
        out.append('<p>'+inline(' '.join(buf))+'</p>')
    return '\n'.join(out)
css='''[hidden]{display:none!important}*{box-sizing:border-box}html{scroll-behavior:smooth}body{margin:0;background:#f4f6f8;color:#203443;font:17px/1.85 system-ui,-apple-system,"PingFang SC","Microsoft YaHei",sans-serif}nav{position:fixed;width:285px;height:100vh;overflow:auto;background:#102d3e;color:#d9e8ef;padding:28px 20px}nav a{display:block;color:#d7e7ee;text-decoration:none;font-size:14px;padding:7px 9px;border-radius:7px;line-height:1.6}nav a:hover,nav a.active{background:#265468;color:white}nav h1{font-size:23px;line-height:1.5;margin:0 0 16px}.meta{font-size:13px;color:#a7c5d1}input{width:100%;padding:11px;border:1px solid #6f8e9d;border-radius:8px;margin:16px 0;background:#f5f8fb;color:#173a4a;font:inherit;font-size:14px}main{margin-left:285px;max-width:1500px;padding:45px 5vw 90px}header{background:#173e52;color:white;padding:38px;border-radius:18px;margin-bottom:28px}header h1{font-size:36px;margin:5px 0 15px;line-height:1.45}header p{color:#d5e5ec}header a{color:#cff0ff}.badge{letter-spacing:.15em;font-size:13px;color:#b6dce9}article{background:white;border:1px solid #dfe7ec;border-radius:16px;padding:32px 40px;margin:28px 0;scroll-margin-top:18px}h2{font-size:29px;color:#133c50;border-bottom:3px solid #e4eff3;padding-bottom:20px;line-height:1.5;margin:0 0 30px}h3{font-size:23px;margin-top:38px;color:#16536a}h4{font-size:19px}a{color:#096782;text-underline-offset:3px}p{margin:17px 0}strong{color:#16495e}code{font:14px/1.7 ui-monospace,SFMono-Regular,Consolas,monospace;background:#edf3f6;border-radius:4px;padding:2px 5px;overflow-wrap:anywhere}pre{background:#112f40;color:#deebf3;padding:26px 22px;overflow:auto;border-radius:10px;font:14px/1.75 ui-monospace,SFMono-Regular,Consolas,monospace;tab-size:4}pre code{background:none;padding:0;color:inherit;overflow-wrap:normal}.codebox{position:relative}.copy{position:absolute;right:9px;top:9px;background:#396075;color:white;border:0;border-radius:5px;padding:5px 10px;cursor:pointer}.tablewrap{overflow-x:auto;margin:24px 0}table{border-collapse:collapse;width:100%;font-size:15px}th,td{border:1px solid #dce5eb;padding:12px 15px;text-align:left;vertical-align:top;min-width:100px}th{background:#eaf2f6;color:#204e63}tr:nth-child(even){background:#f8fafb}figure{margin:28px 0}figure svg{width:100%;height:auto;display:block;border:1px solid #dce7eb;border-radius:12px}figcaption{font-size:13px;color:#607888;text-align:center;margin:10px}details{border:1px solid #dae6eb;border-radius:8px;padding:12px;margin-bottom:25px}summary{cursor:pointer;color:#245c74}details pre{max-height:650px}#count{font-size:13px;color:#b5d2dd;min-height:20px}footer{color:#637988;font-size:14px}button.top{position:fixed;bottom:20px;right:24px;padding:10px 15px;border:0;border-radius:12px;background:#1e566f;color:white;cursor:pointer}@media(max-width:1000px){nav{position:relative;width:100%;height:auto;max-height:370px}main{margin:0;padding:22px}article{padding:25px}header h1{font-size:29px}}@media print{nav,.copy,.top{display:none}main{margin:0;padding:0}article{border:0;break-before:page;padding:0}header{color:black;background:white}pre{white-space:pre-wrap;color:black;background:#eee}details pre{max-height:none}a{color:inherit}body{font-size:11pt;background:white}}'''
nav=[];articles=[]
for p in chapter_files:
    title=p.read_text().splitlines()[0].lstrip('# ');cid=chapter_map[p.name]
    nav.append(f'<a href="#{cid}" data-id="{cid}">{esc(title)}</a>')
    articles.append(f'<article id="{cid}">'+render(p.read_text(),p.name.startswith('17-'))+'</article>')
js='''const q=document.querySelector('#search'),arts=[...document.querySelectorAll('article')],links=[...document.querySelectorAll('nav a[data-id]')];q.addEventListener('input',()=>{let v=q.value.trim().toLowerCase(),n=0;arts.forEach(a=>{let yes=!v||a.textContent.toLowerCase().includes(v);a.hidden=!yes;if(yes)n++;let l=links.find(l=>l.dataset.id===a.id);l.hidden=!yes});document.querySelector('#count').textContent=v?`匹配 ${n} 个章节（按全文检索）`:''});links.forEach(l=>l.addEventListener('click',()=>{links.forEach(x=>x.classList.remove('active'));l.classList.add('active')}));document.querySelectorAll('.copy').forEach(b=>b.addEventListener('click',async()=>{let t=b.parentElement.querySelector('code').textContent;try{await navigator.clipboard.writeText(t);b.textContent='已复制'}catch(e){let r=document.createRange();r.selectNodeContents(b.parentElement.querySelector('code'));let s=window.getSelection();s.removeAllRanges();s.addRange(r);b.textContent='已选中，请复制'}setTimeout(()=>b.textContent='复制',1800)}));document.querySelector('.top').onclick=()=>window.scrollTo({top:0,behavior:'smooth'});'''
page='<!doctype html><html lang="zh-CN"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Linux 5.15 · 进程全链路学习手册</title><style>'+css+'</style></head><body><nav><h1>Linux 5.15<br>进程全链路</h1><div class="meta">x86-64 · 当前源码 · 离线学习<br>2026-09-12 独立学习目录</div><label for="search" class="meta">搜索概念、函数或字段</label><input id="search" placeholder="如 copy_mm / 僵尸 / thread.sp"><div id="count" aria-live="polite"></div>'+''.join(nav)+'</nav><main><header><div class="badge">SOURCE → STRUCTURES → EXECUTION → EVIDENCE</div><h1>从第一个 task，读到最后一次 wait</h1><p>把进程身份、内存资源、CPU 执行现场和生命周期放在同一张地图上。先读全景，再追原码，最后用实验回答“我凭什么知道”。</p><p>18 章 · 9 张离线图 · 6 个用户实验 · 关键函数原文与错误分支</p><a href="README.md">目录说明</a> · <a href="evidence/验证报告.md">实测与限制</a> · <a href="evidence/source-index.json">源码定位索引</a></header>'+''.join(articles)+'<footer>源码版本与证据见 evidence；本页不访问网络。源码摘录保留原文件许可，教学材料由当前工作树生成。</footer></main><button class="top" type="button">回到顶部</button><script>'+js+'</script></body></html>'
(ROOT/'index.html').write_text(page)
print(json.dumps({'chapters':len(chapter_files),'source_excerpts':len(records),'diagrams':len(list(D.glob('*.svg'))),'html_bytes':len(page.encode())},ensure_ascii=False))
