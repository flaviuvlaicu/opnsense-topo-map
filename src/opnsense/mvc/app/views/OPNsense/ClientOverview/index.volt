{#  OPNsense Client Overview v12.2 #}
<style>
/* Kill page scroll — this view fills the viewport */
html.co-page,html.co-page body{overflow:hidden!important;height:100%!important;max-width:100vw!important}
html.co-page .container-fluid,html.co-page .content{overflow:hidden!important}

/* ── Tabs ── */
.co-tabs{display:flex;gap:0;border-bottom:2px solid #e2e2ea;background:#fff;padding:0 16px}
.co-tab{padding:10px 20px;font-size:13px;font-weight:500;cursor:pointer;border-bottom:2px solid transparent;margin-bottom:-2px;color:#8c8ca1;transition:all .15s;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,Arial,sans-serif}
.co-tab:hover{color:#555}.co-tab.active{color:#1a1a2e;border-bottom-color:#3b82f6}
.co-tab-content{display:none}.co-tab-content.active{display:block}

/* ── Shared ── */
.co-wrap *,.tp-wrap *{box-sizing:border-box}

/* ── Clients tab ── */
.co-wrap{display:flex;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,Arial,sans-serif;color:#1a1a2e;background:#f6f6f8;border-radius:0 0 8px 8px;overflow:hidden;border:1px solid #e2e2ea;border-top:0;min-width:0}
.co-list{flex:1;display:flex;flex-direction:column;min-width:0;background:#fff;border-right:1px solid #e2e2ea}
.co-topbar{display:flex;align-items:center;justify-content:space-between;padding:14px 16px;border-bottom:1px solid #eee;flex-shrink:0}.co-topbar-left{display:flex;align-items:center;gap:12px}.co-topbar h2{font-size:18px;font-weight:600;margin:0}.co-client-count{font-size:13px;color:#8c8ca1}.co-topbar-right{display:flex;align-items:center;gap:8px}
.co-search-box{position:relative}.co-search-box input{padding:7px 12px 7px 32px;border:1px solid #ddd;border-radius:6px;font-size:13px;width:200px;outline:none;background:#f6f6f8;transition:border .15s}.co-search-box input:focus{border-color:#3b82f6;background:#fff}.co-search-box .fa-search{position:absolute;left:10px;top:50%;transform:translateY(-50%);color:#aaa;font-size:12px}
.co-filters{display:flex;gap:6px;padding:8px 16px;border-bottom:1px solid #eee;flex-shrink:0;flex-wrap:wrap}.co-pill{padding:3px 10px;border-radius:14px;font-size:11px;cursor:pointer;border:1px solid #e0e0e0;background:#fff;color:#555;transition:all .15s;user-select:none}.co-pill:hover{background:#f0f0f0}.co-pill.active{background:#1a1a2e;color:#fff;border-color:#1a1a2e}
.co-col-header{display:grid;grid-template-columns:24px 36px 1fr 106px 50px 100px 130px;align-items:center;padding:7px 14px;border-bottom:1px solid #eee;font-size:10px;font-weight:600;text-transform:uppercase;color:#8c8ca1;letter-spacing:.5px;flex-shrink:0;gap:2px}
.co-col-header span{cursor:pointer;user-select:none;display:flex;align-items:center;gap:3px;white-space:nowrap}.co-col-header span:hover{color:#555}.co-sort-arrow{font-size:9px;opacity:.3}.co-sort-arrow.active{opacity:1;color:#3b82f6}
.co-rows{flex:1;overflow-y:auto}
.co-row{display:grid;grid-template-columns:24px 36px 1fr 106px 50px 100px 130px;align-items:center;padding:7px 14px;border-bottom:1px solid #f5f5f5;cursor:pointer;transition:background .1s;min-height:44px;gap:2px}.co-row:hover{background:#f8f9fb}.co-row.selected{background:#eef2ff}
.co-dot{width:8px;height:8px;border-radius:50%;justify-self:center}.co-dot.online{background:#22c55e;box-shadow:0 0 4px rgba(34,197,94,.4)}.co-dot.offline{background:#d1d5db}
.co-row-icon{width:32px;height:32px;border-radius:5px;background:#f0f0f5;display:flex;align-items:center;justify-content:center;overflow:hidden;flex-shrink:0}.co-row-icon img{width:100%;height:100%;object-fit:contain;padding:1px}.co-row-icon svg{width:18px;height:18px}
.co-row-info{min-width:0;padding-left:4px}.co-row-name{font-size:12px;font-weight:500;color:#1a1a2e;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}.co-row-name .co-mac-sfx{color:#b0b0c0;font-weight:400;margin-left:3px;font-size:10px}
.co-row-ip{font-family:monospace;font-size:11px;color:#555;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.co-row-vlan{font-size:11px;color:#8c8ca1;text-align:center}
/* Flat network: hide VLAN column */
.co-no-vlan .co-h-vlan,.co-no-vlan .co-row-vlan{display:none}
.co-no-vlan .co-col-header,.co-no-vlan .co-row{grid-template-columns:24px 36px 1fr 106px 100px 130px}
.co-row-type{font-size:10px;color:#666;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.co-row-vendor{font-size:10px;color:#8c8ca1;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;text-align:right}

/* ── Detail panel ── */
.co-detail{width:340px;flex-shrink:0;display:flex;flex-direction:column;background:#fff;overflow-y:auto;overflow-x:hidden;transition:width .2s;border-left:1px solid #e2e2ea}.co-detail.hidden{width:0;overflow:hidden;border:0;padding:0}
.co-detail-head{display:flex;align-items:center;justify-content:space-between;padding:14px 16px;border-bottom:1px solid #eee}.co-detail-head h3{font-size:15px;font-weight:600;margin:0;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}.co-detail-close{cursor:pointer;font-size:18px;color:#999;background:none;border:none;padding:4px}.co-detail-close:hover{color:#333}
.co-detail-icon-area{display:flex;flex-direction:column;align-items:center;padding:20px 16px 12px}
.co-detail-icon-wrap{width:110px;height:110px;border-radius:14px;background:#f0f0f5;display:flex;align-items:center;justify-content:center;overflow:hidden;position:relative;cursor:pointer;transition:box-shadow .15s}.co-detail-icon-wrap:hover{box-shadow:0 0 0 3px rgba(59,130,246,.12),0 2px 12px rgba(0,0,0,.08)}.co-detail-icon-wrap img{width:100%;height:100%;object-fit:contain;padding:6px}.co-detail-icon-wrap svg{width:50px;height:50px}
.co-change-lbl{position:absolute;bottom:0;left:0;right:0;background:rgba(0,0,0,.55);color:#fff;font-size:10px;font-weight:600;text-align:center;padding:3px 0;text-transform:uppercase;letter-spacing:.5px;opacity:0;transition:opacity .15s}.co-detail-icon-wrap:hover .co-change-lbl{opacity:1}
.co-detail-product{margin-top:8px;font-size:13px;font-weight:600;color:#1a1a2e}.co-detail-mactop{font-size:11px;color:#8c8ca1;margin-top:2px;font-family:monospace}
.co-detail-info{padding:0 16px;flex:1}
.co-drow{display:flex;justify-content:space-between;align-items:center;padding:9px 0;border-bottom:1px solid #f0f0f5;font-size:12px}.co-drow:last-child{border-bottom:none}
.co-dlbl{color:#8c8ca1;white-space:nowrap;min-width:80px;flex-shrink:0}.co-dval{color:#1a1a2e;font-weight:500;text-align:right;word-break:break-all;min-width:0}.co-dval.on{color:#22c55e}.co-dval.off{color:#aaa}
.co-badge{padding:2px 8px;border-radius:4px;font-size:11px;font-weight:500}.co-badge.static{background:#e8f5e9;color:#2e7d32}.co-badge.dynamic{background:#e3f2fd;color:#1565c0}.co-badge.arp{background:#fff3e0;color:#e65100}
.co-ename{display:flex;align-items:center;gap:4px}.co-ename input{padding:4px 8px;border:1px solid #ddd;border-radius:5px;font-size:12px;width:120px;outline:none}.co-ename input:focus{border-color:#3b82f6}.co-ename button{padding:4px 10px;border:none;border-radius:5px;cursor:pointer;font-size:11px;font-weight:500;background:#3b82f6;color:#fff}.co-ename button:hover{background:#2563eb}
.co-drow-full{padding:9px 0;border-bottom:1px solid #f0f0f5;font-size:12px}.co-drow-full .co-dlbl{display:block;margin-bottom:5px}
/* Custom dropdown — no <select> to avoid OPNsense CSS bugs */
.co-dd{position:relative;width:100%}
.co-dd-val{padding:8px 30px 8px 10px;border:1px solid #ddd;border-radius:5px;background:#fff;color:#1a1a2e;font-size:13px;cursor:pointer;user-select:none;font-family:inherit}
.co-dd-val::after{content:'▾';position:absolute;right:10px;top:50%;transform:translateY(-50%);color:#888;font-size:12px;pointer-events:none}
.co-dd-list{display:none;position:absolute;top:100%;left:0;right:0;background:#fff;border:1px solid #ddd;border-radius:5px;box-shadow:0 4px 16px rgba(0,0,0,.1);z-index:100;max-height:200px;overflow-y:auto;margin-top:2px}
.co-dd.open .co-dd-list{display:block}
.co-dd-opt{padding:7px 10px;font-size:12px;cursor:pointer;transition:background .1s}.co-dd-opt:hover{background:#f0f4ff}.co-dd-opt.sel{background:#eef2ff;font-weight:500;color:#3b82f6}

/* ── Topology tab (light) ── */
.tp-wrap{display:flex;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,Arial,sans-serif;color:#1a1a2e;background:#f6f6f8;border-radius:0 0 8px 8px;overflow:hidden;border:1px solid #e2e2ea;border-top:0;min-width:0}
.tp-sidebar{width:220px;background:#fff;border-right:1px solid #e2e2ea;display:flex;flex-direction:column;flex-shrink:0}
.tp-sidebar-header{padding:12px 14px;border-bottom:1px solid #eee;display:flex;align-items:center;justify-content:space-between}
.tp-sidebar-header h3{font-size:14px;font-weight:600;margin:0}.tp-sidebar-count{font-size:11px;color:#8c8ca1}
.tp-sidebar-search{padding:8px 12px;border-bottom:1px solid #eee}
.tp-sidebar-search input{width:100%;padding:6px 10px;border:1px solid #ddd;border-radius:5px;background:#f6f6f8;color:#1a1a2e;font-size:11px;outline:none;font-family:inherit}.tp-sidebar-search input:focus{border-color:#3b82f6}.tp-sidebar-search input::placeholder{color:#aaa}
.tp-sidebar-list{flex:1;overflow-y:auto;padding:6px}
.tp-grp-title{font-size:9px;font-weight:600;text-transform:uppercase;letter-spacing:.8px;color:#8c8ca1;padding:6px 8px 2px}
.tp-sdev{display:flex;align-items:center;gap:8px;padding:6px 8px;border-radius:5px;cursor:grab;color:#1a1a2e;font-size:11px;transition:background .1s;user-select:none}
.tp-sdev:hover{background:#f0f0f5}.tp-sdev:active{cursor:grabbing}.tp-sdev.placed{opacity:.3}.tp-sdev.filtered{opacity:.15}
.tp-sdev-icon{width:26px;height:26px;border-radius:4px;background:#f0f0f5;display:flex;align-items:center;justify-content:center;overflow:hidden;flex-shrink:0}.tp-sdev-icon img{width:100%;height:100%;object-fit:contain;padding:1px}.tp-sdev-icon svg{width:14px;height:14px}
.tp-sdev-info{min-width:0;flex:1}.tp-sdev-name{white-space:nowrap;overflow:hidden;text-overflow:ellipsis;font-weight:500}.tp-sdev-ip{font-size:9px;color:#8c8ca1;font-family:monospace}
.tp-sdev-dot{width:5px;height:5px;border-radius:50%;flex-shrink:0}.tp-sdev-dot.on{background:#22c55e}.tp-sdev-dot.off{background:#ccc}

.tp-canvas-area{flex:1;position:relative;overflow:hidden;background:#f8f8fa;min-width:0;cursor:grab}
.tp-canvas-area.panning{cursor:grabbing}
.tp-canvas-area::before{content:'';position:absolute;inset:0;pointer-events:none;background-image:radial-gradient(circle,#ddd .3px,transparent .3px);background-size:18px 18px;opacity:.3;z-index:0}
#tp-world{position:absolute;top:0;left:0;transform-origin:0 0;z-index:1;transition:transform .15s ease-out;will-change:transform}
#tp-world.no-transition{transition:none!important}
#tp-svg{position:absolute;top:0;left:0;pointer-events:none;z-index:1;overflow:visible}
#tp-svg path{pointer-events:stroke;cursor:pointer}
#tp-svg path{stroke-width:1;opacity:.18;transition:opacity .25s ease,stroke-width .25s ease}
#tp-svg path.tp-line-path{stroke-width:1.2;opacity:.4}
#tp-svg circle{opacity:.2;transition:opacity .25s ease}
/* Context menu */
.tp-ctx{position:fixed;z-index:300;background:#fff;border:1px solid #e2e2ea;border-radius:8px;padding:4px 0;min-width:160px;box-shadow:0 4px 20px rgba(0,0,0,.12),0 0 0 1px rgba(0,0,0,.04);font-size:12px;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;opacity:0;transform:scale(.96);transition:opacity .1s,transform .1s;pointer-events:none}
.tp-ctx.show{opacity:1;transform:scale(1);pointer-events:auto}
.tp-ctx-item{padding:6px 14px;cursor:pointer;display:flex;align-items:center;gap:8px;color:#333;transition:background .1s}
.tp-ctx-item:hover{background:#f5f5f8}
.tp-ctx-item i{width:14px;text-align:center;color:#999;font-size:11px}
.tp-ctx-item.danger{color:#ef4444}.tp-ctx-item.danger i{color:#ef4444}
.tp-ctx-sep{height:1px;background:#eee;margin:4px 0}
.tp-ctx-sub{position:relative}
.tp-ctx-sub .tp-ctx-arrow{margin-left:auto;color:#bbb;font-size:9px}
.tp-ctx-sub-menu{position:absolute;left:100%;top:-4px;background:#fff;border:1px solid #e2e2ea;border-radius:8px;padding:4px 0;min-width:140px;box-shadow:0 4px 16px rgba(0,0,0,.1);display:none;max-height:260px;overflow-y:auto}
.tp-ctx-sub:hover .tp-ctx-sub-menu{display:block}
.tp-ctx-sub-menu .tp-ctx-item{font-size:11px;padding:5px 12px}
/* Line tooltip */
.tp-line-tip{position:fixed;z-index:250;background:rgba(30,30,40,.88);color:#fff;padding:6px 10px;border-radius:6px;font-size:11px;pointer-events:none;opacity:0;transition:opacity .15s;backdrop-filter:blur(8px);white-space:nowrap;line-height:1.5;font-family:-apple-system,sans-serif}
.tp-line-tip.show{opacity:1}
.tp-line-tip b{font-weight:600;color:#fff}
.tp-line-tip .tip-row{display:flex;gap:8px;align-items:center}
.tp-line-tip .tip-label{color:rgba(255,255,255,.5);font-size:10px;min-width:36px}
.tp-toast{position:fixed;bottom:24px;left:50%;transform:translateX(-50%) translateY(10px);background:rgba(30,30,40,.88);color:#fff;padding:6px 16px;border-radius:6px;font-size:12px;pointer-events:none;opacity:0;transition:opacity .2s,transform .2s;z-index:400;backdrop-filter:blur(8px)}
.tp-toast.show{opacity:1;transform:translateX(-50%) translateY(0)}
#tp-canvas{position:absolute;top:0;left:0;z-index:2}
.tp-empty{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);text-align:center;color:#aaa;pointer-events:none;z-index:0}.tp-empty h3{font-size:16px;font-weight:300;color:#888;margin-bottom:6px}.tp-empty p{font-size:11px;opacity:.6}
.tp-toolbar{position:absolute;top:12px;right:12px;display:flex;gap:5px;z-index:50}
.tp-legend-bar{position:absolute;top:52px;right:12px;display:flex;gap:6px;align-items:center;flex-wrap:wrap;z-index:50;justify-content:flex-end;max-width:60%}
.tp-legend-item{display:flex;align-items:center;gap:3px;font-size:10px;color:#666;cursor:pointer;padding:2px 6px;border-radius:4px;transition:all .15s;user-select:none;white-space:nowrap}
.tp-legend-item:hover{background:rgba(0,0,0,.05)}
.tp-vl-dot{cursor:pointer;transition:transform .15s}
.tp-vl-dot:hover{transform:scale(1.4)}
.tp-legend-item.off{opacity:.3}
.tp-legend-item.off .tp-vl-name{text-decoration:line-through}
.tp-btn{padding:5px 10px;border-radius:6px;border:1px solid #e0e0e5;background:#fff;color:#666;font-size:10.5px;font-weight:500;cursor:pointer;font-family:inherit;display:flex;align-items:center;gap:4px;transition:all .15s;box-shadow:0 1px 2px rgba(0,0,0,.04)}
.tp-btn:hover{background:#f5f5f8;border-color:#ccc;color:#333}.tp-btn.primary{background:#3b82f6;border-color:#3b82f6;color:#fff;box-shadow:0 1px 3px rgba(59,130,246,.2)}.tp-btn.primary:hover{background:#2563eb}
.tp-toggle.active{background:#2a2a3e;color:#fff;border-color:#2a2a3e;box-shadow:none}.tp-toggle.active:hover{background:#3a3a4e}

/* Circular node badges — refined */
.tp-node{position:absolute;cursor:grab;z-index:5;user-select:none;display:flex;flex-direction:column;align-items:center;gap:1px;width:72px;transition:left .3s cubic-bezier(.4,0,.2,1),top .3s cubic-bezier(.4,0,.2,1),opacity .25s}
.tp-node.notransition{transition:none!important}
#tp-canvas.no-anim .tp-node{transition:none!important}
.tp-node:hover{z-index:20}.tp-node.dragging{cursor:grabbing;z-index:100;transition:none!important}.tp-node.drop-target .tn-box{box-shadow:0 0 0 2px #3b82f6,0 0 12px rgba(59,130,246,.15)}
.tp-node .tn-box{width:44px;height:44px;border-radius:50%;background:#fff;border:1.5px solid #e5e5ea;display:flex;align-items:center;justify-content:center;overflow:hidden;transition:box-shadow .3s ease,border-color .3s ease,transform .15s;position:relative;box-shadow:0 1px 3px rgba(0,0,0,.05);margin:0 auto}
.tp-node:hover .tn-box{transform:scale(1.05);box-shadow:0 2px 8px rgba(0,0,0,.08)}
/* Hover highlight system */
#tp-world.tp-hovering .tp-node{opacity:.15;transition:opacity .25s ease}
#tp-world.tp-hovering .tp-node.tp-path{opacity:1}
#tp-world.tp-hovering #tp-svg path:not(.tp-line-path){opacity:.03}
#tp-world.tp-hovering #tp-svg circle{opacity:.03}
.tp-node.tp-dim,.tp-node.tp-glow{/* compat */}
.tp-node .tn-box img{width:100%;height:100%;object-fit:contain;padding:5px}.tp-node .tn-box svg{width:22px;height:22px;opacity:.7}
.tp-node .tn-label{font-size:9px;font-weight:500;text-align:center;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;color:#444;max-width:72px;line-height:1.2}
.tp-node .tn-sublabel{font-size:0;color:#999;font-family:ui-monospace,SFMono-Regular,monospace;text-align:center;overflow:hidden;transition:font-size .15s,opacity .15s;opacity:0;max-width:72px}
.tp-node:hover .tn-sublabel{font-size:7.5px;opacity:.7}
.tp-node .tn-online{position:absolute;bottom:0;right:0;width:7px;height:7px;border-radius:50%;background:#34d399;border:1.5px solid #fff}
.tp-node .tn-port{position:absolute;top:-5px;left:50%;transform:translateX(-50%);background:rgba(0,0,0,.55);color:#fff;font-size:6px;font-weight:600;padding:1px 4px;border-radius:6px;font-family:-apple-system,sans-serif;white-space:nowrap;cursor:pointer;z-index:10;letter-spacing:.2px;backdrop-filter:blur(4px)}
.tp-node .tn-port:hover{background:rgba(0,0,0,.75)}
.tp-node.selected .tn-box{border-color:#3b82f6;box-shadow:0 0 0 2px rgba(59,130,246,.15)}

.tp-lasso{position:absolute;border:1.5px dashed #3b82f6;background:rgba(59,130,246,.06);pointer-events:none;z-index:100}

.tp-port-popup{display:none;position:fixed;z-index:200;background:#fff;border:1px solid #e2e2ea;border-radius:6px;padding:10px;box-shadow:0 8px 30px rgba(0,0,0,.12)}
.tp-port-popup.show{display:block}
.tp-port-popup label{font-size:10px;color:#8c8ca1;display:block;margin-bottom:3px}
.tp-port-popup input{width:110px;padding:5px 7px;border:1px solid #ddd;border-radius:4px;background:#f6f6f8;color:#1a1a2e;font-size:11px;outline:none;font-family:monospace}
.tp-port-popup input:focus{border-color:#3b82f6}
.tp-port-popup .pp-btns{display:flex;gap:4px;margin-top:6px}
.tp-port-popup .pp-btn{padding:3px 8px;border-radius:3px;border:none;font-size:10px;cursor:pointer;font-family:inherit}
.tp-port-popup .pp-save{background:#3b82f6;color:#fff}.tp-port-popup .pp-cancel{background:#f0f0f5;color:#888}

/* VLAN color picker */
.tp-cpick{position:fixed;z-index:200;background:#fff;border:1px solid #e2e2ea;border-radius:8px;padding:10px;box-shadow:0 8px 30px rgba(0,0,0,.12);display:none}
.tp-cpick.show{display:block}
.tp-cpick-title{font-size:10px;font-weight:600;color:#8c8ca1;margin-bottom:6px}
.tp-cpick-grid{display:grid;grid-template-columns:repeat(6,24px);gap:4px}
.tp-cpick-swatch{width:24px;height:24px;border-radius:5px;cursor:pointer;border:2px solid transparent;transition:all .1s}
.tp-cpick-swatch:hover{transform:scale(1.15)}.tp-cpick-swatch.sel{border-color:#1a1a2e}
.tp-cpick-custom{margin-top:6px;display:flex;align-items:center;gap:6px}
.tp-cpick-custom input[type=color]{width:28px;height:28px;border:1px solid #ddd;border-radius:4px;cursor:pointer;padding:0;background:none}
.tp-cpick-custom span{font-size:10px;color:#888}

/* ── Modal ── */
.co-modal-overlay{display:none;position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,.5);z-index:10000;align-items:center;justify-content:center}.co-modal-overlay.show{display:flex}
.co-modal{background:#fff;border-radius:12px;width:720px;max-width:90vw;max-height:80vh;display:flex;flex-direction:column;box-shadow:0 20px 60px rgba(0,0,0,.2)}
.co-modal-header{display:flex;align-items:center;justify-content:space-between;padding:16px 20px;border-bottom:1px solid #eee;flex-shrink:0}.co-modal-header h3{font-size:16px;font-weight:600;margin:0}.co-modal-close{cursor:pointer;font-size:20px;color:#999;background:none;border:none;padding:4px;line-height:1}.co-modal-close:hover{color:#333}
.co-modal-toolbar{display:flex;gap:8px;padding:12px 20px;border-bottom:1px solid #eee;flex-shrink:0;align-items:center}
.co-modal-search{flex:1;position:relative}.co-modal-search input{width:100%;padding:8px 12px 8px 32px;border:1px solid #ddd;border-radius:6px;font-size:13px;outline:none;background:#f6f6f8}.co-modal-search input:focus{border-color:#3b82f6;background:#fff}.co-modal-search .fa-search{position:absolute;left:10px;top:50%;transform:translateY(-50%);color:#aaa;font-size:12px}
.co-modal-upload{padding:8px 16px;border:1px solid #3b82f6;border-radius:6px;background:#fff;color:#3b82f6;font-size:12px;font-weight:500;cursor:pointer;white-space:nowrap;transition:all .15s}.co-modal-upload:hover{background:#3b82f6;color:#fff}
.co-modal-reset{padding:8px 12px;border:1px solid #ddd;border-radius:6px;background:#fff;color:#888;font-size:12px;cursor:pointer;white-space:nowrap}.co-modal-reset:hover{background:#fee2e2;border-color:#fca5a5;color:#b91c1c}
.co-modal-body{flex:1;overflow-y:auto;padding:12px 16px}.co-modal-count{font-size:12px;color:#8c8ca1;padding:0 4px;white-space:nowrap}
.co-icon-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(100px,1fr));gap:8px}
.co-icon-cell{display:flex;flex-direction:column;align-items:center;padding:10px 4px;border-radius:8px;cursor:pointer;transition:all .1s;border:2px solid transparent}.co-icon-cell:hover{background:#f0f4ff;border-color:#c7d2fe}
.co-icon-cell img{width:64px;height:64px;object-fit:contain}.co-icon-cell span{font-size:10px;color:#666;text-align:center;margin-top:4px;line-height:1.2;max-height:2.4em;overflow:hidden;word-break:break-word;width:100%}

.co-loading{display:flex;align-items:center;justify-content:center;height:200px;color:#aaa;font-size:14px;gap:8px}
/* Topology path icon sizing */
.co-detail-info img{max-width:100%;max-height:100%}
.co-detail-info svg{max-width:100%;max-height:100%}
.co-btn-r{padding:6px 10px;border:1px solid #ddd;border-radius:6px;background:#fff;cursor:pointer;color:#666;font-size:13px}.co-btn-r:hover{background:#f0f0f0}.co-empty{text-align:center;padding:60px 20px;color:#aaa}.co-empty i{font-size:32px;margin-bottom:12px;display:block}
</style>

<!-- Tabs -->
<div class="co-tabs">
  <div class="co-tab active" data-tab="clients"><i class="fa fa-list"></i> Clients</div>
  <div class="co-tab" data-tab="topology"><i class="fa fa-sitemap"></i> Topology</div>
</div>

<!-- ═══ Clients Tab ═══ -->
<div class="co-tab-content active" id="tab-clients">
<div class="co-wrap">
<div class="co-list">
    <div class="co-topbar"><div class="co-topbar-left"><h2>Clients</h2><span class="co-client-count" id="co-count"></span></div><div class="co-topbar-right"><div class="co-search-box"><i class="fa fa-search"></i><input type="text" id="co-search" placeholder="Search..."/></div><button class="co-btn-r" id="co-refresh" title="Refresh"><i class="fa fa-refresh"></i></button></div></div>
    <div class="co-filters" id="co-filters"><span class="co-pill active" data-filter="all">All</span><span class="co-pill" data-filter="online">Online</span><span class="co-pill" data-filter="offline">Offline</span></div>
    <div class="co-col-header"><span></span><span></span><span data-sort="name">Name <i class="fa fa-sort co-sort-arrow" id="sa-name"></i></span><span data-sort="ip">IP <i class="fa fa-sort co-sort-arrow" id="sa-ip"></i></span><span data-sort="vlan" class="co-h-vlan" style="text-align:center">VLAN <i class="fa fa-sort co-sort-arrow" id="sa-vlan"></i></span><span data-sort="type">Type <i class="fa fa-sort co-sort-arrow" id="sa-type"></i></span><span data-sort="vendor" style="text-align:right">Vendor <i class="fa fa-sort co-sort-arrow" id="sa-vendor"></i></span></div>
    <div class="co-rows" id="co-rows"><div class="co-loading"><i class="fa fa-spinner fa-spin"></i> Loading...</div></div>
</div>
<div class="co-detail hidden" id="co-detail"></div>
</div>
</div>

<!-- ═══ Topology Tab ═══ -->
<div class="co-tab-content" id="tab-topology">
<div class="tp-wrap">
  <div class="tp-sidebar">
    <div class="tp-sidebar-header"><h3>Devices</h3><span class="tp-sidebar-count" id="tp-count"></span></div>
    <div class="tp-sidebar-search"><input type="text" id="tp-filter" placeholder="Filter..."></div>
    <div class="tp-sidebar-list" id="tp-sidebar-list"></div>
  </div>
  <div class="tp-canvas-area" id="tp-canvas-area">
    <div id="tp-world">
      <svg id="tp-svg"></svg>
      <div id="tp-canvas"></div>
    </div>
    <div class="tp-empty" id="tp-empty"><h3>Drag devices here to build your topology</h3><p>Drop devices onto each other to create connections</p></div>
    <div class="tp-toolbar">
      <div style="display:flex;gap:4px;margin-right:8px;border-right:1px solid #ddd;padding-right:8px">
        <button class="tp-btn tp-toggle" id="tp-f-infra" title="Show only infrastructure"><i class="fa fa-server"></i> Infra</button>
        <button class="tp-btn tp-toggle" id="tp-f-wired" title="Show only wired devices"><i class="fa fa-plug"></i> Wired</button>
        <button class="tp-btn tp-toggle" id="tp-f-online" title="Show only online devices"><i class="fa fa-circle"></i> Online</button>
      </div>
      <button class="tp-btn" id="tp-auto"><i class="fa fa-magic"></i> Auto-layout</button>
      <button class="tp-btn" id="tp-fit"><i class="fa fa-compress"></i> Fit</button>
      <button class="tp-btn" id="tp-clear"><i class="fa fa-trash"></i> Clear</button>
      <button class="tp-btn" id="tp-refresh"><i class="fa fa-refresh"></i></button>
      <button class="tp-btn primary" id="tp-save"><i class="fa fa-save"></i> Save</button>
      <button class="tp-btn" id="tp-kb-help" title="Keyboard shortcuts (?)"><i class="fa fa-keyboard-o"></i></button>
      <span id="tp-sel-count" style="display:none;font-size:10px;color:#3b82f6;font-weight:600;padding:6px 8px;background:rgba(59,130,246,.08);border-radius:5px"></span>
    </div>
    <div id="tp-legend" class="tp-legend-bar"></div>
  </div>
  <div class="co-detail hidden" id="tp-detail"></div>
</div>
<div class="tp-port-popup" id="tp-port-popup"><label>Port Label</label><input type="text" id="tp-pp-input" placeholder="e.g. Port 1"><div class="pp-btns"><button class="pp-btn pp-save" id="tp-pp-save">Save</button><button class="pp-btn pp-cancel" id="tp-pp-cancel">Cancel</button></div></div>
<div class="tp-port-popup" id="tp-speed-popup"><label>Link Speed</label><div class="tp-speed-opts" id="tp-speed-opts"></div><div style="margin-top:6px"><input type="text" id="tp-speed-custom" placeholder="Custom (e.g. 5G)" style="width:100%;padding:5px 8px;border:1px solid #ddd;border-radius:4px;font-size:11px;font-family:inherit;outline:none"></div><div class="pp-btns"><button class="pp-btn pp-save" id="tp-sp-save">Save</button><button class="pp-btn pp-cancel" id="tp-sp-cancel">Cancel</button></div></div>
<div class="tp-ctx" id="tp-ctx"></div>
<div class="tp-line-tip" id="tp-line-tip"></div>
<div class="tp-toast" id="tp-toast"></div>
<div class="tp-cpick" id="tp-cpick">
  <div class="tp-cpick-title" id="tp-cpick-title">VLAN Color</div>
  <div class="tp-cpick-grid" id="tp-cpick-grid"></div>
  <div class="tp-cpick-custom"><input type="color" id="tp-cpick-custom" value="#3b82f6"/><span>Custom</span></div>
</div>
</div>

<!-- Icon browser modal -->
<div class="co-kb-overlay" id="co-kb-overlay" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.45);z-index:500;align-items:center;justify-content:center">
<div style="background:#fff;border-radius:10px;padding:24px 32px;max-width:360px;box-shadow:0 20px 60px rgba(0,0,0,.2);font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Helvetica,Arial,sans-serif">
<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px"><h3 style="margin:0;font-size:16px;font-weight:600">Keyboard Shortcuts</h3><button id="co-kb-close" style="border:none;background:none;font-size:20px;cursor:pointer;color:#999">&times;</button></div>
<div style="display:flex;flex-direction:column;gap:8px;font-size:12px;color:#444">
<div style="display:flex;justify-content:space-between"><span>Save topology</span><kbd style="background:#f0f0f5;padding:2px 6px;border-radius:3px;font-size:10px;font-family:monospace">Ctrl+S</kbd></div>
<div style="display:flex;justify-content:space-between"><span>Select all nodes</span><kbd style="background:#f0f0f5;padding:2px 6px;border-radius:3px;font-size:10px;font-family:monospace">Ctrl+A</kbd></div>
<div style="display:flex;justify-content:space-between"><span>Multi-select</span><kbd style="background:#f0f0f5;padding:2px 6px;border-radius:3px;font-size:10px;font-family:monospace">Ctrl+Click</kbd></div>
<div style="display:flex;justify-content:space-between"><span>Lasso select</span><kbd style="background:#f0f0f5;padding:2px 6px;border-radius:3px;font-size:10px;font-family:monospace">Click+Drag canvas</kbd></div>
<div style="display:flex;justify-content:space-between"><span>Additive lasso</span><kbd style="background:#f0f0f5;padding:2px 6px;border-radius:3px;font-size:10px;font-family:monospace">Ctrl+Lasso</kbd></div>
<div style="display:flex;justify-content:space-between"><span>Delete selected</span><kbd style="background:#f0f0f5;padding:2px 6px;border-radius:3px;font-size:10px;font-family:monospace">Delete</kbd></div>
<div style="display:flex;justify-content:space-between"><span>Deselect all</span><kbd style="background:#f0f0f5;padding:2px 6px;border-radius:3px;font-size:10px;font-family:monospace">Escape</kbd></div>
<div style="display:flex;justify-content:space-between"><span>Auto-arrange node</span><kbd style="background:#f0f0f5;padding:2px 6px;border-radius:3px;font-size:10px;font-family:monospace">Double-click</kbd></div>
<div style="display:flex;justify-content:space-between"><span>This help</span><kbd style="background:#f0f0f5;padding:2px 6px;border-radius:3px;font-size:10px;font-family:monospace">?</kbd></div>
</div>
</div>
</div>
<div class="co-modal-overlay" id="co-modal"><div class="co-modal">
    <div class="co-modal-header"><h3>Choose Icon</h3><button class="co-modal-close" id="co-modal-close">&times;</button></div>
    <div class="co-modal-toolbar"><div class="co-modal-search"><i class="fa fa-search"></i><input type="text" id="co-modal-search" placeholder="Search 5,000+ device icons..."/></div><span class="co-modal-count" id="co-modal-count"></span><button class="co-modal-upload" id="co-modal-upload-btn"><i class="fa fa-upload"></i> Upload</button><button class="co-modal-reset" id="co-modal-reset-btn"><i class="fa fa-undo"></i> Reset</button></div>
    <div class="co-modal-body" id="co-modal-body"></div>
</div></div>
<input type="file" style="display:none" id="co-icon-upload" accept="image/png,image/svg+xml,image/jpeg,image/webp"/>

<script>
$(document).ready(function(){
// Lock page scroll and size containers
$('html').addClass('co-page');
function sizeContainers(){
    var footer=$('.page-foot,.footer,footer').first();
    var footH=footer.length?footer.outerHeight(true):30;
    var tabsTop=$('.co-tabs').offset()?$('.co-tabs').offset().top:0;
    var tabsH=$('.co-tabs').outerHeight()||40;
    var avail=window.innerHeight-tabsTop-tabsH-footH-4;
    avail=Math.max(avail,300);
    $('.co-wrap,.tp-wrap').css('height',avail+'px');
}
sizeContainers();

var allDevices=[],fpIcons=null,fpIconsMac=null,activeTab='clients',hasMultipleVlans=false;
var S={phone:'<svg viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="1.5"><rect x="7" y="2" width="10" height="20" rx="2"/><line x1="12" y1="18" x2="12" y2="18.01" stroke-width="2" stroke-linecap="round"/></svg>',laptop:'<svg viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="1.5"><rect x="3" y="4" width="18" height="12" rx="2"/><line x1="2" y1="20" x2="22" y2="20"/></svg>',desktop:'<svg viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="1.5"><rect x="2" y="3" width="20" height="14" rx="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/></svg>',server:'<svg viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="1.5"><rect x="2" y="2" width="20" height="8" rx="2"/><rect x="2" y="14" width="20" height="8" rx="2"/><circle cx="6" cy="6" r="1" fill="#888"/><circle cx="6" cy="18" r="1" fill="#888"/></svg>',tv:'<svg viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="1.5"><rect x="2" y="3" width="20" height="14" rx="1"/><path d="M8 21h8M12 17v4"/></svg>',mediaplayer:'<svg viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="1.5"><rect x="3" y="6" width="18" height="12" rx="3"/><polygon points="10,9 16,12 10,15" fill="#888"/></svg>',hub:'<svg viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="1.5"><circle cx="12" cy="12" r="4"/><path d="M12 2v6M12 16v6M2 12h6M16 12h6"/></svg>',sensor:'<svg viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="1.5"><path d="M12 2a7 7 0 0 1 7 7c0 3-2 5-3 7h-8c-1-2-3-4-3-7a7 7 0 0 1 7-7z"/><line x1="9" y1="18" x2="15" y2="18"/></svg>',plug:'<svg viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="1.5"><path d="M12 2v6M8 2v6M16 2v6"/><rect x="6" y="8" width="12" height="6" rx="1"/><path d="M10 14v4a2 2 0 0 0 4 0v-4"/></svg>',appliance:'<svg viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="1.5"><rect x="4" y="2" width="16" height="20" rx="2"/><circle cx="12" cy="14" r="4"/></svg>',network:'<svg viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="1.5"><rect x="1" y="8" width="22" height="8" rx="2"/><circle cx="6" cy="12" r="1" fill="#888"/><line x1="16" y1="12" x2="20" y2="12" stroke-linecap="round"/></svg>',camera:'<svg viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="1.5"><rect x="2" y="6" width="20" height="14" rx="2"/><circle cx="12" cy="13" r="4"/></svg>',speaker:'<svg viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="1.5"><rect x="7" y="2" width="10" height="20" rx="5"/><circle cx="12" cy="15" r="3"/></svg>',thermostat:'<svg viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="1.5"><path d="M14 14.76V3.5a2.5 2.5 0 0 0-5 0v11.26a4.5 4.5 0 1 0 5 0z"/></svg>',sbc:'<svg viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="1.5"><rect x="3" y="5" width="18" height="14" rx="1"/><circle cx="6" cy="8" r=".5" fill="#888"/></svg>',unknown:'<svg viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="1.5"><rect x="3" y="3" width="18" height="18" rx="3"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/></svg>'};
var TL={phone:'Phone',laptop:'Laptop',desktop:'Desktop',server:'Server',tv:'TV',mediaplayer:'Media Player',gaming:'Gaming',hub:'Hub',iot:'IoT',sensor:'Sensor',plug:'Smart Plug',thermostat:'Thermostat',appliance:'Appliance',network:'Network',nas:'NAS',printer:'Printer',camera:'Camera',tablet:'Tablet',virtual:'VM',watch:'Watch',speaker:'Speaker',audio:'Audio',sbc:'SBC',unknown:'Unknown'};
var TLF={phone:'Phone',laptop:'Laptop',desktop:'Desktop',server:'Server',tv:'TV',mediaplayer:'Media Player',gaming:'Gaming Console',hub:'Smart Home Hub',iot:'IoT Device',sensor:'Sensor',plug:'Smart Plug',thermostat:'Thermostat',appliance:'Appliance',network:'Network Device',nas:'NAS',printer:'Printer',camera:'Camera',tablet:'Tablet',virtual:'Virtual Machine',watch:'Watch',speaker:'Speaker',audio:'Audio',sbc:'Single Board Computer',unknown:'Unknown'};

function esc(t){if(!t)return'';var d=document.createElement('span');d.textContent=t;return d.innerHTML;}
function isRandomMac(mac){if(!mac||mac.length<2)return false;var b=parseInt(mac.charAt(1),16);return!isNaN(b)&&(b&2)===2;}
function ico(c){if(c.custom_icon)return'<img src="'+esc(c.custom_icon)+'?_='+Date.now()+'"/>';if(c.fp_icon)return'<img src="'+esc(c.fp_icon)+'"/>';return S[c.device_type]||S.unknown;}
function sfx(m){if(!m)return'';var p=m.split(':');return p.slice(-2).join(':');}
function dn(c){return c.custom_name||c.hostname||'';}
function vlan(c){
    // Use backend-provided vlan if available
    if(c.vlan&&c.vlan!=='')return c.vlan;
    // Fallback: try to extract from IP
    var m=c.ip.match(/^\d+\.\d+\.(\d+)\./);
    return m?m[1]:'-';
}
function ipNum(ip){var p=ip.split('.');return((+p[0])<<24)+((+p[1])<<16)+((+p[2])<<8)+(+p[3]);}
var devMap={};
function buildDevMap(){devMap={};allDevices.forEach(function(d){devMap[d.mac]=d;});}
function getDev(mac){return devMap[mac];}

// ── Shared detail builder using custom dropdown ──
function buildDetailHtml(c){
    var n=dn(c)||c.mac,pr=c.product||c.vendor||'Unknown Device';
    var h='<div class="co-detail-head"><h3>'+esc(n)+'</h3><button class="co-detail-close">&times;</button></div>';
    h+='<div class="co-detail-icon-area"><div class="co-detail-icon-wrap co-icon-click">'+ico(c)+'<div class="co-change-lbl">Change Icon</div></div>';
    h+='<div class="co-detail-product">'+esc(pr)+'</div><div class="co-detail-mactop">'+esc(c.mac)+(isRandomMac(c.mac)?'<span style="margin-left:6px;font-size:8px;font-weight:600;color:#f59e0b;background:#fef3c7;padding:1px 5px;border-radius:3px;font-family:-apple-system,sans-serif" title="This device uses a randomized MAC address and may appear as a new device when the MAC rotates">Random</span>':'')+'</div></div>';
    h+='<div class="co-detail-info">';
    h+='<div class="co-drow"><span class="co-dlbl">Alias</span><div class="co-ename"><input class="co-ealias" placeholder="Custom name..." value="'+esc(c.custom_name||'')+'"/><button class="co-save-a">Save</button></div></div>';
    h+='<div class="co-drow"><span class="co-dlbl">IP Address</span><span class="co-dval">'+esc(c.ip)+'</span></div>';
    if(hasMultipleVlans)h+='<div class="co-drow"><span class="co-dlbl">VLAN</span><span class="co-dval">'+esc(vlan(c))+'</span></div>';
    h+='<div class="co-drow"><span class="co-dlbl">Status</span><span class="co-dval '+(c.online?'on':'off')+'">'+(c.online?'Online':'Offline')+'</span></div>';
    if(c.last_seen){var ls=new Date(c.last_seen*1000);var ago=Math.floor((Date.now()/1000-c.last_seen)/60);var lsText;if(ago<1)lsText='Just now';else if(ago<60)lsText=ago+' min ago';else if(ago<1440)lsText=Math.floor(ago/60)+' hr ago';else lsText=Math.floor(ago/1440)+' days ago';h+='<div class="co-drow"><span class="co-dlbl">Last Seen</span><span class="co-dval">'+lsText+'</span></div>';}
    if(c.first_seen){var fs=new Date(c.first_seen*1000);h+='<div class="co-drow"><span class="co-dlbl">First Seen</span><span class="co-dval">'+fs.toLocaleDateString()+'</span></div>';}
    h+='<div class="co-drow"><span class="co-dlbl">Hostname</span><span class="co-dval">'+esc(c.hostname||'-')+'</span></div>';
    h+='<div class="co-drow"><span class="co-dlbl">Manufacturer</span><span class="co-dval">'+esc(c.vendor||'-')+'</span></div>';
    if(c.product)h+='<div class="co-drow"><span class="co-dlbl">Model</span><span class="co-dval">'+esc(c.product)+'</span></div>';
    // Custom dropdown instead of <select>
    h+='<div class="co-drow-full"><span class="co-dlbl">Device Type</span>';
    h+='<div class="co-dd" data-mac="'+esc(c.mac)+'"><div class="co-dd-val">'+(TLF[c.device_type]||'Unknown')+'</div><div class="co-dd-list">';
    Object.keys(TLF).forEach(function(t){h+='<div class="co-dd-opt'+(t===c.device_type?' sel':'')+'" data-val="'+t+'">'+TLF[t]+'</div>';});
    h+='</div></div></div>';
    h+='<div class="co-drow"><span class="co-dlbl">Lease Type</span><span class="co-dval"><span class="co-badge '+(c.lease_type||'dynamic')+'">'+esc((c.lease_type||'dynamic').toUpperCase())+'</span></span></div>';
    h+='<div class="co-drow"><span class="co-dlbl">MAC</span><span class="co-dval" style="font-family:monospace;font-size:11px">'+esc(c.mac)+'</span></div>';

    // ── Port Manager (for network devices in topology) ──
    if(topo&&topo.nodes&&topo.nodes[c.mac]){
        var isNetDev=c.device_type==='network'||c.device_type==='router'||c.device_type==='gateway';
        var children=Object.keys(topo.nodes).filter(function(m){return topo.nodes[m].parent===c.mac;});
        if(isNetDev||children.length>0){
            h+='<div style="padding:12px 0 4px;border-top:1px solid #f0f0f5">';
            h+='<div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:8px">';
            h+='<span class="co-dlbl" style="margin:0">Ports</span>';
            h+='<button class="tp-add-port-btn" data-mac="'+esc(c.mac)+'" style="padding:2px 8px;border:1px solid #ddd;border-radius:4px;background:#fff;color:#3b82f6;font-size:10px;cursor:pointer;font-family:inherit"><i class="fa fa-plus" style="margin-right:3px"></i>Add</button>';
            h+='</div>';
            if(children.length>0){
                h+='<div style="display:flex;flex-direction:column;gap:4px">';
                children.sort(function(a,b){
                    var pa=topo.nodes[a].port||'';var pb=topo.nodes[b].port||'';
                    return pa.localeCompare(pb,undefined,{numeric:true});
                }).forEach(function(m){
                    var nd=topo.nodes[m],dv=getDev(m);
                    var prt=nd.port||'';
                    var spd=nd.speed||'';
                    var v=dv?vlan(dv):'-';
                    var col=VLAN_COLORS[v]||'#888';
                    var vname=esc(VLAN_NAMES[v]||'V'+v);
                    var dname=dv?(dn(dv)||dv.mac):m;
                    h+='<div class="tp-port-row" style="display:flex;align-items:center;gap:6px;padding:5px 8px;background:#f8f9fb;border-radius:5px;font-size:11px">';
                    h+='<span class="tp-port-label" data-mac="'+m+'" style="min-width:48px;padding:2px 6px;background:'+col+';color:#fff;border-radius:3px;font-size:9px;font-weight:600;font-family:monospace;cursor:pointer;text-align:center" title="Click to rename">'+esc(prt||'—')+'</span>';
                    h+='<span style="flex:1;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;color:#1a1a2e;font-weight:500">'+esc(dname)+'</span>';
                    if(spd)h+='<span style="font-size:8px;font-weight:600;color:#888;background:#f0f0f5;padding:1px 5px;border-radius:3px;font-family:monospace">'+esc(spd)+'</span>';
                    if(hasMultipleVlans&&v!=='-')h+='<span style="font-size:8px;font-weight:600;color:'+col+';background:'+col+'15;padding:1px 5px;border-radius:3px">'+vname+'</span>';
                    h+='<button class="tp-detach-port" data-mac="'+m+'" style="border:none;background:none;color:#ccc;cursor:pointer;font-size:12px;padding:2px 4px" title="Detach device"><i class="fa fa-times"></i></button>';
                    h+='</div>';
                });
                h+='</div>';
            }else{
                h+='<div style="font-size:11px;color:#aaa;padding:4px 0">No connected devices</div>';
            }
            h+='</div>';
        }
    }

    // Device actions: Wake-on-LAN (offline only) + Forget (always)
    h+='<div style="padding:10px 0;border-top:1px solid #f0f0f5;display:flex;gap:6px">';
    if(!c.online){
        h+='<button class="co-wol-btn" data-mac="'+esc(c.mac)+'" style="flex:1;padding:7px;border:1px solid #93c5fd;border-radius:5px;background:#fff;color:#3b82f6;font-size:11px;cursor:pointer;font-family:inherit;font-weight:500;transition:all .15s"><i class="fa fa-power-off" style="margin-right:4px"></i>Wake</button>';
    }
    h+='<button class="co-forget-btn" data-mac="'+esc(c.mac)+'" style="flex:1;padding:7px;border:1px solid #fca5a5;border-radius:5px;background:#fff;color:#ef4444;font-size:11px;cursor:pointer;font-family:inherit;font-weight:500;transition:all .15s"><i class="fa fa-trash" style="margin-right:4px"></i>Forget</button>';
    h+='</div>';
    // Topology chain — show path from root to this device
    if(topo&&topo.nodes&&topo.nodes[c.mac]){
        var chain=[];var cur=c.mac;var seen={};
        while(cur&&topo.nodes[cur]&&!seen[cur]){
            seen[cur]=true;
            var nd=topo.nodes[cur],dv=getDev(cur);
            chain.unshift({mac:cur,dev:dv,port:nd.port,speed:nd.speed,vlan:dv?vlan(dv):'-'});
            cur=nd.parent;
        }
        if(chain.length>0){
            h+='<div style="padding:12px 0 4px"><span class="co-dlbl" style="display:block;margin-bottom:8px">Topology Path</span>';
            h+='<div style="display:flex;flex-direction:column;gap:0;padding-left:4px">';
            chain.forEach(function(item,i){
                var col=VLAN_COLORS[item.vlan]||'#888';
                var name=item.dev?(dn(item.dev)||item.dev.mac):item.mac;
                var isLast=i===chain.length-1;
                h+='<div style="display:flex;align-items:center;gap:8px">';
                h+='<div style="width:30px;height:30px;min-width:30px;border-radius:6px;background:#f0f0f5;display:flex;align-items:center;justify-content:center;overflow:hidden;flex-shrink:0">';
                if(item.dev){
                    var ic=ico(item.dev);
                    ic=ic.replace(/<img /,'<img style="width:100%;height:100%;object-fit:contain;padding:2px" ');
                    ic=ic.replace(/<svg /,'<svg style="width:18px;height:18px" ');
                    h+=ic;
                }
                h+='</div>';
                h+='<div style="flex:1;min-width:0">';
                h+='<div style="font-size:11px;font-weight:'+(isLast?'600':'500')+';color:'+(isLast?'#1a1a2e':'#555')+';white-space:nowrap;overflow:hidden;text-overflow:ellipsis">'+esc(name)+'</div>';
                if(item.dev)h+='<div style="font-size:9px;color:#8c8ca1;font-family:monospace">'+esc(item.dev.ip)+'</div>';
                h+='</div>';
                if(hasMultipleVlans&&item.vlan!=='-')h+='<span style="font-size:8px;font-weight:600;color:'+col+';background:'+col+'18;padding:1px 5px;border-radius:3px">'+esc(VLAN_NAMES[item.vlan]||'V'+item.vlan)+'</span>';
                h+='</div>';
                if(!isLast){
                    var nextItem=chain[i+1];
                    var nextCol=VLAN_COLORS[nextItem.vlan]||'#ccc';
                    h+='<div style="display:flex;flex-direction:column;align-items:center;padding:3px 0;margin-left:15px">';
                    h+='<div style="width:1px;height:8px;background:'+nextCol+';opacity:.5"></div>';
                    if(nextItem.port)h+='<span style="font-size:8px;font-weight:500;color:'+nextCol+';padding:1px 6px;border-radius:3px;font-family:monospace">'+esc(nextItem.port)+'</span>';
                    if(nextItem.speed)h+='<span style="font-size:7px;font-weight:600;color:#aaa;padding:1px 4px;font-family:monospace">'+esc(nextItem.speed)+'</span>';
                    h+='<div style="width:1px;height:6px;background:'+nextCol+';opacity:.5"></div>';
                    h+='<div style="width:0;height:0;border-left:3.5px solid transparent;border-right:3.5px solid transparent;border-top:4px solid '+nextCol+';opacity:.5"></div>';
                    h+='</div>';
                }
            });
            h+='</div></div>';
        }
    }else if(topo&&topo.nodes){
        // Device not in topology — show hint
        h+='<div style="padding:10px 0;border-top:1px solid #f0f0f5"><div style="font-size:10px;color:#bbb;text-align:center"><i class="fa fa-sitemap" style="margin-right:4px"></i>Not in topology — drag to the Topology tab to place</div></div>';
    }
    // Remove from topology button (only in topology tab)
    if(activeTab==='topology'&&topo&&topo.nodes&&topo.nodes[c.mac]){
        h+='<div style="padding:12px 0;border-top:1px solid #f0f0f5;margin-top:4px;text-align:center"><button class="tp-remove-btn" data-mac="'+esc(c.mac)+'" style="padding:6px 16px;border:1px solid #fca5a5;border-radius:5px;background:#fff;color:#ef4444;font-size:11px;cursor:pointer;font-family:inherit;font-weight:500;transition:all .15s"><i class="fa fa-trash" style="margin-right:4px"></i>Remove from Topology</button></div>';
    }
    h+='</div>';
    return h;
}

// Custom dropdown events
$(document).on('click','.co-dd-val',function(e){e.stopPropagation();$('.co-dd').not($(this).parent()).removeClass('open');$(this).parent().toggleClass('open');});
$(document).on('click','.co-dd-opt',function(e){e.stopPropagation();var dd=$(this).closest('.co-dd'),mac=dd.data('mac'),val=$(this).data('val');dd.find('.co-dd-val').text($(this).text());dd.find('.co-dd-opt').removeClass('sel');$(this).addClass('sel');dd.removeClass('open');if(mac)$.post('/api/clientoverview/service/setDevice',{mac:mac,device_type:val},function(){fetchClients();},'json').fail(function(){alert('Failed to update device type');});});
$(document).on('click',function(){$('.co-dd').removeClass('open');});

// Tab switching
$('.co-tab').on('click',function(){
    var newTab=$(this).data('tab');
    if(activeTab==='topology'&&newTab!=='topology'&&tpDirty){
        if(!confirm('You have unsaved topology changes. Switch tab anyway?'))return;
    }
    activeTab=newTab;$('.co-tab').removeClass('active');$(this).addClass('active');$('.co-tab-content').removeClass('active');$('#tab-'+activeTab).addClass('active');sizeContainers();if(activeTab==='topology'){initTopo();renderTpSidebar();setTimeout(fitToView,200);}
});

// ════════════════════════════════════════
// CLIENTS TAB
// ════════════════════════════════════════
var selMac=null,filter='all',sortBy='name',sortDir='asc';
function fetchClients(){$.ajax({url:'/api/clientoverview/service/clients',type:'GET',dataType:'json',success:function(d){if(d&&d.clients){allDevices=d.clients;buildDevMap();
// Merge backend VLAN names into VLAN_NAMES
if(d.vlan_names){Object.keys(d.vlan_names).forEach(function(v){VLAN_NAMES[v]=d.vlan_names[v];});}
// Detect if network has multiple VLANs
var vlans={};allDevices.forEach(function(c){var v=vlan(c);if(v!=='-')vlans[v]=1;});
hasMultipleVlans=Object.keys(vlans).length>1;
buildTypePills();renderList();if(selMac&&activeTab==='clients'){var s=getDev(selMac);if(s)showDetail('co-detail',s);}if(tpInited){_filteredCache=null;rebuildTopo();renderTpSidebar();}$('#co-refresh i').css('color','');}},error:function(){$('#co-refresh i').css('color','#ef4444');}});}
var typePillsBuilt=false;
function buildTypePills(){if(typePillsBuilt)return;typePillsBuilt=true;var types={};allDevices.forEach(function(c){var t=c.device_type||'unknown';types[t]=(types[t]||0)+1;});var sorted=Object.keys(types).sort(function(a,b){return types[b]-types[a];});var h='<span class="co-pill active" data-filter="all">All</span><span class="co-pill" data-filter="online">Online</span><span class="co-pill" data-filter="offline">Offline</span><span style="border-left:1px solid #ddd;margin:0 2px"></span>';sorted.forEach(function(t){if(t==='unknown'&&types[t]<2)return;h+='<span class="co-pill" data-filter="type:'+t+'">'+(TL[t]||t)+' <span style="opacity:.5">'+types[t]+'</span></span>';});$('#co-filters').html(h);}
function getF(){var s=$('#co-search').val().toLowerCase();return allDevices.filter(function(c){if(filter==='online'&&!c.online)return false;if(filter==='offline'&&c.online)return false;if(filter.indexOf('type:')===0&&c.device_type!==filter.substring(5))return false;if(s){var h=[c.hostname,c.custom_name,c.ip,c.mac,c.vendor,c.device_type,c.product].join(' ').toLowerCase();if(h.indexOf(s)===-1)return false;}return true;});}
function sortClients(cs){cs.sort(function(a,b){var va,vb,r;switch(sortBy){case'ip':r=ipNum(a.ip)-ipNum(b.ip);break;case'vlan':va=vlan(a);vb=vlan(b);r=(va==='-'?9999:+va)-(vb==='-'?9999:+vb);break;case'vendor':va=(a.vendor||'zzz').toLowerCase();vb=(b.vendor||'zzz').toLowerCase();r=va.localeCompare(vb);break;case'type':va=(TL[a.device_type]||'zzz');vb=(TL[b.device_type]||'zzz');r=va.localeCompare(vb);break;default:if(a.online!==b.online)return a.online?-1:1;va=(dn(a)||a.ip).toLowerCase();vb=(dn(b)||b.ip).toLowerCase();r=va.localeCompare(vb);}return sortDir==='desc'?-r:r;});return cs;}
function updateSortArrows(){$('.co-sort-arrow').removeClass('active fa-sort-up fa-sort-down').addClass('fa-sort');$('#sa-'+sortBy).addClass('active').removeClass('fa-sort').addClass(sortDir==='asc'?'fa-sort-up':'fa-sort-down');}
function renderList(){var cs=sortClients(getF());var on=allDevices.filter(function(c){return c.online}).length;$('#co-count').text(on+'/'+allDevices.length);updateSortArrows();
// Hide VLAN column on flat networks
$('.co-wrap').toggleClass('co-no-vlan',!hasMultipleVlans);
if(!cs.length){$('#co-rows').html('<div class="co-empty"><i class="fa fa-search"></i>No match.</div>');return;}var h='';cs.forEach(function(c){var n=dn(c),sf='';if(!n)n=c.mac;else sf=' <span class="co-mac-sfx">'+esc(sfx(c.mac))+'</span>';h+='<div class="co-row'+(c.mac===selMac?' selected':'')+'" data-mac="'+esc(c.mac)+'"><div class="co-dot '+(c.online?'online':'offline')+'"></div><div class="co-row-icon">'+ico(c)+'</div><div class="co-row-info"><div class="co-row-name">'+esc(n)+sf+'</div></div><div class="co-row-ip">'+esc(c.ip)+'</div><div class="co-row-vlan">'+esc(vlan(c))+'</div><div class="co-row-type">'+esc(TL[c.device_type]||c.device_type)+'</div><div class="co-row-vendor">'+esc(c.vendor||'-')+'</div></div>';});var el=$('#co-rows'),st=el.scrollTop();el.html(h);el.scrollTop(st);}

function showDetail(panelId,c){selMac=c.mac;$('#'+panelId).html(buildDetailHtml(c)).removeClass('hidden');if(panelId==='co-detail'){$('.co-row').removeClass('selected');$('.co-row[data-mac="'+c.mac+'"]').addClass('selected');}if(panelId==='tp-detail'){$('.tp-node').removeClass('selected');$('.tp-node[data-mac="'+c.mac+'"]').addClass('selected');}}

$(document).on('click','.co-col-header span[data-sort]',function(){var s=$(this).data('sort');if(sortBy===s)sortDir=sortDir==='asc'?'desc':'asc';else{sortBy=s;sortDir='asc';}renderList();});
$(document).on('click','.co-pill',function(){filter=$(this).data('filter');$('.co-pill').removeClass('active');$(this).addClass('active');renderList();});
$(document).on('click','.co-row',function(){var c=getDev($(this).data('mac'));if(c)showDetail('co-detail',c);});
$(document).on('click','.co-detail-close',function(){selMac=null;tpSelMac=null;$(this).closest('.co-detail').addClass('hidden');$('.co-row,.tp-node').removeClass('selected');clearPathHighlight();});
$(document).on('click','.co-forget-btn',function(){var mac=$(this).data('mac');if(!mac)return;if(!confirm('Forget this device? It will be removed from all lists and topology.'))return;$.post('/api/clientoverview/service/forgetDevice',{mac:mac},function(r){if(r&&r.status==='ok'){selMac=null;$('.co-detail').addClass('hidden');fetchClients();if(tpInited){if(tpDirty&&topo.nodes[mac]){
    // Remove locally to avoid overwriting unsaved changes
    getChildren(mac).forEach(function(ch){if(topo.nodes[ch]){topo.nodes[ch].parent=null;topo.nodes[ch].port=null;}});
    delete topo.nodes[mac];rebuildTopo();
}else{loadTopo();}}}else{alert('Failed to forget device');}},'json').fail(function(){alert('Failed to forget device — network error');});});
$(document).on('click','.co-wol-btn',function(){
    var btn=$(this),mac=btn.data('mac');if(!mac)return;
    btn.prop('disabled',true).html('<i class="fa fa-spinner fa-spin" style="margin-right:4px"></i>Sending...');
    $.post('/api/clientoverview/service/wakeDevice',{mac:mac},function(r){
        if(r&&r.status==='ok'){
            btn.html('<i class="fa fa-check" style="margin-right:4px"></i>Sent!').css({color:'#22c55e',borderColor:'#86efac'});
            setTimeout(function(){btn.prop('disabled',false).html('<i class="fa fa-power-off" style="margin-right:4px"></i>Wake').css({color:'#3b82f6',borderColor:'#93c5fd'});},3000);
        }else{
            btn.html('<i class="fa fa-times" style="margin-right:4px"></i>Failed').css({color:'#ef4444',borderColor:'#fca5a5'});
            setTimeout(function(){btn.prop('disabled',false).html('<i class="fa fa-power-off" style="margin-right:4px"></i>Wake').css({color:'#3b82f6',borderColor:'#93c5fd'});},3000);
        }
    },'json').fail(function(){
        btn.html('<i class="fa fa-times" style="margin-right:4px"></i>Error').css({color:'#ef4444',borderColor:'#fca5a5'});
        setTimeout(function(){btn.prop('disabled',false).html('<i class="fa fa-power-off" style="margin-right:4px"></i>Wake').css({color:'#3b82f6',borderColor:'#93c5fd'});},3000);
    });
});
$('#co-search').on('input',function(){renderList();});
$('#co-refresh').on('click',fetchClients);
$('#co-kb-close').on('click',function(){$('#co-kb-overlay').hide();});
$('#co-kb-overlay').on('click',function(e){if(e.target===this)$(this).hide();});
$('#tp-kb-help').on('click',function(){$('#co-kb-overlay').css('display','flex');});
$(document).on('click','.co-save-a',function(){if(!selMac)return;var p=$(this).closest('.co-detail');var val=p.find('.co-ealias').val()||'';var btn=$(this);btn.prop('disabled',true).text('Saving...');$.post('/api/clientoverview/service/setDevice',{mac:selMac,name:val},function(){btn.prop('disabled',false).text('Save');fetchClients();},'json').fail(function(){btn.prop('disabled',false).text('Save');alert('Failed to save alias');});});

// Icon browser
$(document).on('click','.co-icon-click',function(){if(!selMac)return;fpIconsMac=selMac;$('#co-modal').addClass('show');$('#co-modal-search').val('').focus();if(!fpIcons){$('#co-modal-body').html('<div style="text-align:center;padding:40px;color:#aaa"><i class="fa fa-spinner fa-spin"></i></div>');$.ajax({url:'/api/clientoverview/service/icons',type:'GET',dataType:'json',success:function(d){if(d&&d.icons){fpIcons=d.icons;renderIconGrid('');}},error:function(){$('#co-modal-body').html('<div style="text-align:center;padding:40px;color:#aaa">Error</div>');}});}else renderIconGrid('');});
function renderIconGrid(q){var f=fpIcons;if(q){var ql=q.toLowerCase();f=fpIcons.filter(function(i){return i.name.toLowerCase().indexOf(ql)!==-1;});}$('#co-modal-count').text(f.length+' icons');if(!f.length){$('#co-modal-body').html('<div style="text-align:center;padding:40px;color:#aaa">No match</div>');return;}var show=f.slice(0,200);var h='<div class="co-icon-grid">';show.forEach(function(i){h+='<div class="co-icon-cell" data-url="'+esc(i.url)+'"><img src="'+esc(i.url)+'" loading="lazy"/><span>'+esc(i.name)+'</span></div>';});h+='</div>';if(f.length>200)h+='<div style="text-align:center;padding:16px;color:#888;font-size:12px">Showing 200 of '+f.length+'</div>';$('#co-modal-body').html(h);}
$('#co-modal-close').on('click',function(){$('#co-modal').removeClass('show');});
$('#co-modal').on('click',function(e){if(e.target===this)$(this).removeClass('show');});
var st;$('#co-modal-search').on('input',function(){var q=$(this).val();clearTimeout(st);st=setTimeout(function(){renderIconGrid(q);},200);});
$(document).on('click','.co-icon-cell',function(){var u=$(this).data('url');if(!fpIconsMac||!u)return;$.post('/api/clientoverview/service/setDevice',{mac:fpIconsMac,fp_icon:u},function(){$('#co-modal').removeClass('show');fetchClients();},'json').fail(function(){alert('Failed to set icon');});});
$('#co-modal-upload-btn').on('click',function(){if(!fpIconsMac)return;$('#co-icon-upload').data('mac',fpIconsMac).click();});
$('#co-icon-upload').on('change',function(){var m=$(this).data('mac');if(!m||!this.files.length)return;var fd=new FormData();fd.append('mac',m);fd.append('icon',this.files[0]);$.ajax({url:'/api/clientoverview/service/uploadIcon',type:'POST',data:fd,processData:false,contentType:false,dataType:'json',headers:{'X-CSRFToken':$('input[name="__opnsense_csrf"]').val()||''},success:function(r){if(r&&r.status==='ok'){$('#co-modal').removeClass('show');fetchClients();}else{alert('Upload failed: '+(r.message||'unknown error'));}},error:function(xhr){var msg='Upload failed';try{var r=JSON.parse(xhr.responseText);msg=r.message||r.errorMessage||msg;}catch(e){}alert(msg);}});$(this).val('');});
$('#co-modal-reset-btn').on('click',function(){if(!fpIconsMac)return;$.post('/api/clientoverview/service/clearIcon',{mac:fpIconsMac},function(){$('#co-modal').removeClass('show');fetchClients();},'json').fail(function(){alert('Failed to reset icon');});});

// ════════════════════════════════════════
// TOPOLOGY TAB — Proper tree layout
// ════════════════════════════════════════
var topo={nodes:{}},tpDragging=null,tpDragOff={x:0,y:0},tpDropTarget=null,tpDragFromSidebar=null,tpInited=false,tpEditMac=null,tpSelMac=null,tpDidDrag=false,tpDirty=false;
var tpHiddenVlans={}; // VLANs toggled off in legend
// Zoom & Pan state
var tpZoom=1,tpPanX=0,tpPanY=0,tpPanning=false,tpPanStart={x:0,y:0},tpWorld=null;
// Force simulation

var tpFilters={infra:false,wired:false,online:false};
var tpSelected={};// mac->true for multi-select
var tpLasso=null;// {startX,startY,el} for box select
var _hoverLeaveTimer=null;// Global hover leave debounce
var _selHighlightMac=null;// Persistent selection highlight (stays while panel open)

function applyPathHighlight(mac){
    if(!tpCanvas||!tpSvg||!tpWorld)return;
    clearTimeout(_hoverLeaveTimer);
    clearPathHighlight();
    _selHighlightMac=mac;
    var d=getDev(mac);
    var col=d?vlanColor(d):'#999';
    var pathMacs={};pathMacs[mac]=true;
    var cur=mac;
    while(topo.nodes[cur]&&topo.nodes[cur].parent){cur=topo.nodes[cur].parent;pathMacs[cur]=true;}
    tpWorld.classList.add('tp-hovering');
    var nodes=tpCanvas.querySelectorAll('.tp-node');
    for(var i=0;i<nodes.length;i++){
        if(pathMacs[nodes[i].dataset.mac])nodes[i].classList.add('tp-path');
    }
    var paths=tpSvg.querySelectorAll('path[data-mac]');
    for(var i=0;i<paths.length;i++){
        var m=paths[i].getAttribute('data-mac');
        if(m&&pathMacs[m]){paths[i].setAttribute('stroke',col);paths[i].classList.add('tp-line-path');}
    }
    var circles=tpSvg.querySelectorAll('circle[data-mac]');
    for(var i=0;i<circles.length;i++){
        var m=circles[i].getAttribute('data-mac');
        if(m&&pathMacs[m])circles[i].setAttribute('fill',col);
    }
}
function clearPathHighlight(){
    _selHighlightMac=null;
    if(!tpWorld)return;
    tpWorld.classList.remove('tp-hovering');
    var marked=tpCanvas.querySelectorAll('.tp-path');
    for(var i=0;i<marked.length;i++)marked[i].classList.remove('tp-path');
    var glowPaths=tpSvg.querySelectorAll('.tp-line-path');
    for(var i=0;i<glowPaths.length;i++){
        var c=glowPaths[i].getAttribute('data-color');
        if(c)glowPaths[i].setAttribute('stroke',c);
        glowPaths[i].classList.remove('tp-line-path');
    }
    var circles=tpSvg.querySelectorAll('circle[data-mac]');
    for(var i=0;i<circles.length;i++){
        var c=circles[i].getAttribute('data-color');
        if(c)circles[i].setAttribute('fill',c);
    }
}
var tpGroupDrag=null;// {offsets:{mac:{dx,dy}}} for group dragging
var NODE_W=72,NODE_H=62,GAP_X=36,GAP_Y=48;
var VLAN_COLORS={'1':'#22c55e','2':'#06b6d4','10':'#a855f7','20':'#f59e0b','30':'#ef4444','40':'#3b82f6','50':'#ec4899'};
var VLAN_NAMES={};// Populated from backend Kea config
var EXTRA_COLORS=['#14b8a6','#f97316','#8b5cf6','#64748b','#84cc16','#e11d48','#0ea5e9','#d946ef','#78716c','#fb923c','#2dd4bf','#7c3aed'];
var _extraIdx=0;
function vlanColor(c){var v=vlan(c);if(VLAN_COLORS[v])return VLAN_COLORS[v];if(v==='-')return'#888';VLAN_COLORS[v]=EXTRA_COLORS[_extraIdx%EXTRA_COLORS.length];_extraIdx++;return VLAN_COLORS[v];}
function vlanName(c){var v=vlan(c);return esc(VLAN_NAMES[v]||'VLAN '+v);}
var tpCanvas,tpSvg,tpArea;

function initTopo(){if(tpInited)return;tpInited=true;tpCanvas=document.getElementById('tp-canvas');tpSvg=document.getElementById('tp-svg');tpArea=document.getElementById('tp-canvas-area');tpWorld=document.getElementById('tp-world');initLineTip();loadTopo();
// Suppress browser context menu on canvas (we use our own)
tpArea.addEventListener('contextmenu',function(e){e.preventDefault();});
// Zoom: scroll wheel on canvas (with dead zone to prevent accidental zoom)
var tpScrollAccum=0,tpScrollTimer=null;
tpArea.addEventListener('wheel',function(e){
    e.preventDefault();hideCtxMenu();hideLineTip();
    e.stopPropagation();
    // Detect if this is a pinch gesture (ctrlKey on Mac trackpad) — zoom immediately
    if(e.ctrlKey||e.metaKey){
        var rect=tpArea.getBoundingClientRect();
        var mx=e.clientX-rect.left,my=e.clientY-rect.top;
        var oldZ=tpZoom;
        var delta=e.deltaY>0?0.94:1.06;
        tpZoom=Math.max(0.2,Math.min(2.5,tpZoom*delta));
        tpPanX=mx-(mx-tpPanX)*(tpZoom/oldZ);
        tpPanY=my-(my-tpPanY)*(tpZoom/oldZ);
        applyZoomPan();
        return;
    }
    // Regular scroll: accumulate and zoom once threshold hit
    tpScrollAccum+=e.deltaY;
    clearTimeout(tpScrollTimer);
    tpScrollTimer=setTimeout(function(){tpScrollAccum=0;},300);
    if(Math.abs(tpScrollAccum)>50){
        var rect=tpArea.getBoundingClientRect();
        var mx=e.clientX-rect.left,my=e.clientY-rect.top;
        var oldZ=tpZoom;
        var delta=tpScrollAccum>0?0.92:1.08;
        tpZoom=Math.max(0.2,Math.min(2.5,tpZoom*delta));
        tpPanX=mx-(mx-tpPanX)*(tpZoom/oldZ);
        tpPanY=my-(my-tpPanY)*(tpZoom/oldZ);
        applyZoomPan();
        tpScrollAccum=0;
    }
},{passive:false});
// Pan: left-drag on empty canvas area
var _panStartPos=null;
tpArea.addEventListener('mousedown',function(e){
    if(e.target===tpArea||e.target===tpWorld||e.target.id==='tp-svg'||e.target.closest('#tp-empty')||e.target===tpCanvas){
        if(e.button===0&&!e.shiftKey){
            _panStartPos={x:e.clientX,y:e.clientY};
            tpPanning=true;tpPanStart={x:e.clientX-tpPanX,y:e.clientY-tpPanY};
            tpArea.classList.add('panning');
            tpWorld.classList.add('no-transition');
            hideCtxMenu();hideLineTip();
            e.preventDefault();
        }
    }
});
document.addEventListener('mousemove',function(e){
    if(tpPanning){
        tpPanX=e.clientX-tpPanStart.x;
        tpPanY=e.clientY-tpPanStart.y;
        applyZoomPan();
    }
});
document.addEventListener('mouseup',function(e){
    if(tpPanning){
        tpPanning=false;tpArea.classList.remove('panning');tpWorld.classList.remove('no-transition');
        // If barely moved = click on empty canvas → close panel
        if(_panStartPos){
            var dx=Math.abs(e.clientX-_panStartPos.x),dy=Math.abs(e.clientY-_panStartPos.y);
            if(dx<5&&dy<5){
                selMac=null;tpSelMac=null;tpSelected={};updateTpSelection();
                $('#tp-detail').addClass('hidden');
                clearPathHighlight();
            }
            _panStartPos=null;
        }
    }
});
document.addEventListener('mousemove',tpMM);document.addEventListener('mouseup',tpMU);
// Delete/Backspace removes selected nodes from topology
document.addEventListener('keydown',function(e){if(activeTab!=='topology')return;
    // Don't fire if typing in an input
    if(e.target.tagName==='INPUT'||e.target.tagName==='TEXTAREA'||e.target.tagName==='SELECT')return;
    // Ctrl+S: save topology
    if((e.ctrlKey||e.metaKey)&&e.key==='s'){
        e.preventDefault();
        if(tpDirty)saveTopo();return;
    }
    // Ctrl+A: select all visible nodes
    if((e.ctrlKey||e.metaKey)&&e.key==='a'){
        e.preventDefault();
        var visible=getFilteredNodes();
        tpSelected={};Object.keys(visible).forEach(function(m){tpSelected[m]=true;});
        updateTpSelection();return;
    }
    // Escape: deselect all
    if(e.key==='Escape'){
        if($('#co-kb-overlay').is(':visible')){$('#co-kb-overlay').hide();return;}
        tpSelected={};tpSelMac=null;selMac=null;updateTpSelection();
        $('#tp-detail').addClass('hidden');clearPathHighlight();return;
    }
    // ? key: show keyboard shortcuts
    if(e.key==='?'){$('#co-kb-overlay').css('display','flex');return;}
    if(e.key==='Delete'||e.key==='Backspace'){
        var sel=Object.keys(tpSelected);
        if(!sel.length)return;
        e.preventDefault();
        // Unparent children of removed nodes (don't cascade-delete)
        sel.forEach(function(mac){
            getChildren(mac).forEach(function(ch){
                if(!tpSelected[ch]){
                    topo.nodes[ch].parent=null;
                    topo.nodes[ch].port=null;
                }
            });
            delete topo.nodes[mac];
        });
        tpSelected={};tpSelMac=null;
        $('#tp-detail').addClass('hidden');
        markDirty();rebuildTopo();
    }
});
// Lasso select on shift+drag on empty canvas
tpArea.addEventListener('mousedown',function(e){
    if(e.target!==tpArea&&e.target!==tpCanvas&&e.target.id!=='tp-svg'&&!e.target.closest('.tp-empty'))return;
    if(e.button!==0||!e.shiftKey)return;
    // Don't start lasso if we're panning
    if(tpPanning)return;
    e.preventDefault();
    var rect=tpArea.getBoundingClientRect();
    var sx=(e.clientX-rect.left-tpPanX)/tpZoom,sy=(e.clientY-rect.top-tpPanY)/tpZoom;
    var el=document.createElement('div');el.className='tp-lasso';
    el.style.left=sx+'px';el.style.top=sy+'px';el.style.width='0';el.style.height='0';
    tpCanvas.appendChild(el);
    tpLasso={startX:sx,startY:sy,el:el,additive:e.ctrlKey||e.metaKey};
    if(!e.ctrlKey&&!e.metaKey){tpSelected={};updateTpSelection();}
});
tpArea.addEventListener('dragover',function(e){e.preventDefault();if(tpDragFromSidebar)tpCheckDrop(e.clientX,e.clientY,tpDragFromSidebar);});
tpArea.addEventListener('drop',function(e){e.preventDefault();var mac=e.dataTransfer.getData('text/plain');if(!mac||!getDev(mac))return;
var rect=tpArea.getBoundingClientRect();var x=snapToGrid((e.clientX-rect.left-tpPanX)/tpZoom-40),y=snapToGrid((e.clientY-rect.top-tpPanY)/tpZoom-28);
var parent=tpDropTarget&&tpDropTarget!==mac?tpDropTarget:null;
topo.nodes[mac]={x:x,y:y,parent:parent,port:parent&&!isWifiAP(parent)?'Port '+(getChildren(parent).length+1):null};
tpClearDrop();
if(parent){
    // Auto-arrange children under parent with row wrapping
    arrangeChildren(parent,mac);
}
markDirty();rebuildTopo();});}

function getChildren(mac){return Object.keys(topo.nodes).filter(function(m){return topo.nodes[m].parent===mac;});}

// ── Topology filtering ──
function isNetworkInfra(mac){
    var d=getDev(mac);if(!d)return false;
    if(d.device_type==='network'||d.device_type==='router'||d.device_type==='gateway')return true;
    return isWifiAP(mac);
}
function isWifiAP(mac){
    var d=getDev(mac);if(!d)return false;
    var hn=(d.hostname||'').toLowerCase();
    var pr=(d.product||'').toLowerCase();
    var vn=(d.vendor||'').toLowerCase();
    // Check product field first (most reliable from backend classification)
    if(pr.indexOf('unifi ap')!==-1||pr.indexOf('access point')!==-1)return true;
    // Vendor-based AP models
    if(vn.indexOf('ubiquiti')!==-1||vn.indexOf('ruckus')!==-1||vn.indexOf('aruba')!==-1){
        if(hn.match(/\bap\b|\buap\b|\bu[67][a-z]*\b/))return true;
    }
    // Hostname patterns — word boundaries to avoid matching "laptop", "apple"
    if(hn.match(/\bap\b|\buap\b|\bwap\b|\baccess[-_ ]?point\b/))return true;
    if(hn.match(/\bunifi[-_ ]?ap\b|\beap\d|\bwax\d|\bmr\d/))return true;
    if(hn.indexOf('wifi-ap')!==-1||hn.indexOf('wifi_ap')!==-1)return true;
    return false;
}
function getDescendants(mac){
    var result=[],seen={};
    function walk(m){var ch=getChildren(m);ch.forEach(function(c){if(!seen[c]){seen[c]=true;result.push(c);walk(c);}});}
    walk(mac);return result;
}
function getWifiDescendants(){
    // All nodes that are under a WiFi AP
    var wifiMacs={};
    Object.keys(topo.nodes).forEach(function(mac){
        if(isWifiAP(mac)){
            getDescendants(mac).forEach(function(m){wifiMacs[m]=true;});
        }
    });
    return wifiMacs;
}
var _filteredCache=null,_filteredCacheTime=0;
function getFilteredNodes(forceRefresh){
    // Cache for 500ms to avoid recalculating on every mousemove during drag
    var now=Date.now();
    if(!forceRefresh&&_filteredCache&&now-_filteredCacheTime<500)return _filteredCache;
    _filteredCacheTime=now;
    var wifiDesc=getWifiDescendants();
    var visible={};
    Object.keys(topo.nodes).forEach(function(mac){
        var d=getDev(mac);if(!d)return;
        // Online filter: if "online only" is active, hide offline
        if(tpFilters.online&&!d.online)return;
        // Infra filter: show only network infrastructure devices
        if(tpFilters.infra){
            if(d.device_type!=='network'&&d.device_type!=='router'&&d.device_type!=='gateway'&&!isNetworkInfra(mac))return;
        }
        // Wired filter: hide WiFi clients (devices under an AP)
        if(tpFilters.wired){
            if(wifiDesc[mac])return;
        }
        // VLAN filter: hide toggled-off VLANs
        if(Object.keys(tpHiddenVlans).length>0){
            var v=vlan(d);
            if(v&&v!=='-'&&tpHiddenVlans[v])return;
        }
        visible[mac]=true;
    });
    // Ensure parents of visible nodes are also visible (keep tree connected)
    var toAdd=true;
    while(toAdd){
        toAdd=false;
        Object.keys(visible).forEach(function(mac){
            var p=topo.nodes[mac]&&topo.nodes[mac].parent;
            if(p&&topo.nodes[p]&&!visible[p]){visible[p]=true;toAdd=true;}
        });
    }
    _filteredCache=visible;
    return visible;
}

function loadTopo(){$.ajax({url:'/api/clientoverview/service/topology',type:'GET',dataType:'json',success:function(d){
    console.log('loadTopo response:',d?JSON.stringify(d).substring(0,200):'null');
    if(d&&d.topology&&d.topology.nodes){
        var nodeCount=typeof d.topology.nodes==='object'?Object.keys(d.topology.nodes).length:0;
        console.log('loadTopo: loaded '+nodeCount+' nodes, tpDirty='+tpDirty+', current nodes='+Object.keys(topo.nodes).length);
        // Don't overwrite if user has unsaved changes
        if(tpDirty&&Object.keys(topo.nodes).length>0){console.log('loadTopo: skipping — dirty');return;}
        topo=d.topology;
        // Restore view preferences
        if(topo.hiddenVlans&&Array.isArray(topo.hiddenVlans)){
            tpHiddenVlans={};
            topo.hiddenVlans.forEach(function(v){tpHiddenVlans[v+'']=(true);});
            console.log('loadTopo: restored hiddenVlans=',Object.keys(tpHiddenVlans));
        }else{
            console.log('loadTopo: no hiddenVlans in saved data, keys=',Object.keys(topo));
        }
        if(topo.filters){
            if(topo.filters.infra){tpFilters.infra=true;$('#tp-f-infra').addClass('active');}
            if(topo.filters.wired){tpFilters.wired=true;$('#tp-f-wired').addClass('active');}
            if(topo.filters.online){tpFilters.online=true;$('#tp-f-online').addClass('active');}
        }
    }
    // Only auto-layout if nodes exist but lack positions (fresh/corrupted data)
    var needsLayout=false;
    var keys=Object.keys(topo.nodes);
    if(keys.length>0){
        var first=topo.nodes[keys[0]];
        if(first.x===undefined||first.x===null||(first.x===0&&first.y===0&&keys.length>1))needsLayout=true;
    }
    if(needsLayout)autoLayoutTree();
    _filteredCache=null;// Force re-evaluate filters with restored hiddenVlans
    markClean();rebuildTopo();setTimeout(fitToView,200);
},error:function(){rebuildTopo();}});}
function saveTopo(){
    // Save view preferences (hidden VLANs, filters) into topo object
    topo.hiddenVlans=Object.keys(tpHiddenVlans);
    topo.filters={infra:tpFilters.infra||false,wired:tpFilters.wired||false,online:tpFilters.online||false};
    console.log('saveTopo: hiddenVlans=',topo.hiddenVlans,'filters=',topo.filters);
    // Prune orphaned nodes — but ONLY if we have device data loaded
    // Without this check, saving before fetchClients completes would delete everything
    if(allDevices.length>0){
        var pruned=[];
        Object.keys(topo.nodes).forEach(function(mac){
            if(!getDev(mac)){
                // Unparent children before removing
                getChildren(mac).forEach(function(ch){if(topo.nodes[ch]){topo.nodes[ch].parent=null;topo.nodes[ch].port=null;}});
                delete topo.nodes[mac];
                pruned.push(mac);
            }
        });
        if(pruned.length>0)console.log('Topology: pruned '+pruned.length+' orphaned nodes');
    }
    var data=JSON.stringify(topo);
    $.ajax({url:'/api/clientoverview/service/saveTopology',type:'POST',
        data:{topology:data},
        dataType:'json',
        success:function(r){
            if(r&&r.status==='ok'){
                var savedN=r.saved_nodes||0;
                var localN=Object.keys(topo.nodes).length;
                console.log('Save OK: server saved '+savedN+' nodes, local has '+localN);
                if(savedN===0&&localN>0){
                    alert('Warning: save reported 0 nodes saved but you have '+localN+'. Check file permissions on the OPNsense box.');
                }else{
                    markClean();
                    var b=$('#tp-save');b.html('<i class="fa fa-check"></i> Saved!');setTimeout(function(){b.html('<i class="fa fa-save"></i> Save');},1500);
                }
            }
            else{alert('Save failed: '+(r.message||'unknown error'));}
        },
        error:function(){alert('Save request failed');}
    });
}

// ── Proper tree layout algorithm with row wrapping ──
var MAX_PER_ROW=6;

// Arrange children of a parent with row-wrapping (used by drop, double-click, and reparent)
// ── Smart layout engine ──
// Balanced rows, VLAN-sorted, no overlaps

function applyZoomPan(){
    if(tpWorld)tpWorld.style.transform='translate('+tpPanX+'px,'+tpPanY+'px) scale('+tpZoom+')';
}
function resetZoomPan(){
    tpZoom=1;tpPanX=0;tpPanY=0;applyZoomPan();
}
function fitToView(){
    if(!tpArea)return;
    var visible=getFilteredNodes();
    var minX=Infinity,maxX=0,minY=Infinity,maxY=0;
    Object.keys(topo.nodes).forEach(function(m){if(!visible[m])return;var n=topo.nodes[m];minX=Math.min(minX,n.x);maxX=Math.max(maxX,n.x+NODE_W);minY=Math.min(minY,n.y);maxY=Math.max(maxY,n.y+NODE_H);});
    if(minX===Infinity)return;
    var w=maxX-minX+80,h=maxY-minY+80;
    var aW=tpArea.clientWidth,aH=tpArea.clientHeight;
    tpZoom=Math.min(1.5,Math.min(aW/w,aH/h));
    tpPanX=(aW-w*tpZoom)/2-minX*tpZoom+40*tpZoom;
    tpPanY=(aH-h*tpZoom)/2-minY*tpZoom+40*tpZoom;
    applyZoomPan();
}


function sortByVlan(ch){
    if(!hasMultipleVlans)return ch;
    return ch.slice().sort(function(a,b){
        var da=getDev(a),db=getDev(b);
        var va=da?vlan(da):'-',vb=db?vlan(db):'-';
        if(va===vb)return 0;
        if(va==='-')return 1;if(vb==='-')return-1;
        return(parseInt(va)||999)-(parseInt(vb)||999);
    });
}

// Calculate balanced row sizes: e.g. 13 items → [5,4,4] not [8,5]
function balancedRows(n,maxR){
    if(n<=maxR)return[n];
    var numRows=Math.ceil(n/maxR);
    var base=Math.floor(n/numRows);
    var extra=n%numRows;
    var rows=[];
    for(var i=0;i<numRows;i++)rows.push(base+(i<extra?1:0));
    return rows;
}

// Measure subtree width
function measureSubtree(mac,visible){
    var ch=getChildren(mac).filter(function(m){return visible[m];});
    if(!ch.length)return NODE_W;
    ch=sortByVlan(ch);
    var childWidths=ch.map(function(c){return measureSubtree(c,visible);});
    var rowSizes=balancedRows(ch.length,MAX_PER_ROW);
    var maxRowW=0;
    var idx=0;
    rowSizes.forEach(function(sz){
        var w=0;
        for(var i=0;i<sz;i++){w+=childWidths[idx+i];if(i<sz-1)w+=GAP_X;}
        maxRowW=Math.max(maxRowW,w);
        idx+=sz;
    });
    return Math.max(NODE_W,maxRowW);
}

// Measure subtree height
function measureSubtreeH(mac,visible){
    var ch=getChildren(mac).filter(function(m){return visible[m];});
    if(!ch.length)return NODE_H;
    var rowSizes=balancedRows(ch.length,MAX_PER_ROW);
    var total=0;
    var idx=0;
    rowSizes.forEach(function(sz){
        var rowMax=0;
        for(var i=0;i<sz;i++){
            rowMax=Math.max(rowMax,measureSubtreeH(ch[idx+i],visible));
        }
        total+=rowMax+GAP_Y;
        idx+=sz;
    });
    return NODE_H+total;
}

// Layout a subtree at position (left, top) within given width
function layoutSubtree(mac,left,top,width,visible){
    topo.nodes[mac].x=snapToGrid(left+(width-NODE_W)/2);
    topo.nodes[mac].y=snapToGrid(top);
    var ch=getChildren(mac).filter(function(m){return visible[m];});
    if(!ch.length)return;
    ch=sortByVlan(ch);
    var childWidths=ch.map(function(c){return measureSubtree(c,visible);});
    var rowSizes=balancedRows(ch.length,MAX_PER_ROW);
    var rowY=top+NODE_H+GAP_Y;
    var idx=0;
    rowSizes.forEach(function(sz){
        // Calculate this row's total width
        var tw=0;
        for(var i=0;i<sz;i++){tw+=childWidths[idx+i];if(i<sz-1)tw+=GAP_X;}
        // Center row within parent's width
        var cx=left+(width-tw)/2;
        for(var i=0;i<sz;i++){
            var c=ch[idx+i];
            var cw=childWidths[idx+i];
            layoutSubtree(c,cx,rowY,cw,visible);
            cx+=cw+GAP_X;
        }
        // Row height = tallest subtree in row
        var maxH=NODE_H;
        for(var i=0;i<sz;i++){
            maxH=Math.max(maxH,measureSubtreeH(ch[idx+i],visible));
        }
        rowY+=maxH+GAP_Y;
        idx+=sz;
    });
}

// Arrange children under a specific parent (used by drop, dblclick, reparent)
function arrangeChildren(parentMac,newMac){
    var visible=getFilteredNodes();
    if(newMac)visible[newMac]=true;
    var p=topo.nodes[parentMac];if(!p)return;
    var ch=getChildren(parentMac).filter(function(m){return visible[m];});
    if(!ch.length)return;
    ch=sortByVlan(ch);
    var childWidths=ch.map(function(c){return measureSubtree(c,visible);});
    var rowSizes=balancedRows(ch.length,MAX_PER_ROW);

    // Total width of widest row
    var maxRowW=0;
    var idx=0;
    rowSizes.forEach(function(sz){
        var w=0;for(var i=0;i<sz;i++){w+=childWidths[idx+i];if(i<sz-1)w+=GAP_X;}
        maxRowW=Math.max(maxRowW,w);
        idx+=sz;
    });

    var blockLeft=p.x+NODE_W/2-maxRowW/2;
    var rowY=p.y+NODE_H+GAP_Y;
    idx=0;
    rowSizes.forEach(function(sz){
        var tw=0;for(var i=0;i<sz;i++){tw+=childWidths[idx+i];if(i<sz-1)tw+=GAP_X;}
        var cx=blockLeft+(maxRowW-tw)/2;
        for(var i=0;i<sz;i++){
            var c=ch[idx+i];
            var cw=childWidths[idx+i];
            topo.nodes[c].x=snapToGrid(cx+(cw-NODE_W)/2);
            topo.nodes[c].y=snapToGrid(rowY);
            // Recursively arrange grandchildren
            var gk=getChildren(c).filter(function(m){return visible[m];});
            if(gk.length)arrangeChildren(c);
            cx+=cw+GAP_X;
        }
        var maxH=NODE_H;
        for(var i=0;i<sz;i++){maxH=Math.max(maxH,measureSubtreeH(ch[idx+i],visible));}
        rowY+=maxH+GAP_Y;
        idx+=sz;
    });
}

function autoLayoutTree(){
    var visible=getFilteredNodes();
    var roots=Object.keys(topo.nodes).filter(function(m){
        return visible[m]&&(!topo.nodes[m].parent||!topo.nodes[topo.nodes[m].parent]||!visible[topo.nodes[m].parent]);
    });
    if(!roots.length)return;

    var startX=0;
    roots.forEach(function(root){
        var w=measureSubtree(root,visible);
        layoutSubtree(root,startX,0,w,visible);
        startX+=w+GAP_X*3;
    });

    // Center in viewport
    var minX=Infinity,maxX=0,minY=Infinity,maxY=0;
    Object.keys(topo.nodes).forEach(function(m){if(!visible[m])return;var n=topo.nodes[m];minX=Math.min(minX,n.x);maxX=Math.max(maxX,n.x+NODE_W);minY=Math.min(minY,n.y);maxY=Math.max(maxY,n.y+NODE_H);});
    if(minX===Infinity)return;
    var areaW=tpArea.clientWidth||800,areaH=tpArea.clientHeight||600;
    var treeW=maxX-minX,treeH=maxY-minY;
    var offX=Math.max(20,Math.floor((areaW-treeW)/2))-minX;
    var offY=Math.max(20,Math.floor(Math.min(areaH*0.05,(areaH-treeH)/3)))-minY;
    Object.keys(topo.nodes).forEach(function(m){if(!visible[m])return;topo.nodes[m].x+=offX;topo.nodes[m].y+=offY;});
}


function markDirty(){tpDirty=true;$('#tp-save').css('box-shadow','0 0 0 2px rgba(251,146,60,.5)').html('<i class="fa fa-save"></i> Save*');}
function markClean(){tpDirty=false;$('#tp-save').css('box-shadow','').html('<i class="fa fa-save"></i> Save');}
$(window).on('beforeunload',function(){if(tpDirty)return'You have unsaved topology changes.';});

function rebuildTopo(){
    _filteredCache=null;
    tpCanvas.classList.add('no-anim');
    tpCanvas.innerHTML='';
    var visible=getFilteredNodes();
    var minX=Infinity,maxX=0,minY=Infinity,maxY=0,hasNodes=false;
    Object.keys(topo.nodes).forEach(function(mac){if(!visible[mac])return;var n=topo.nodes[mac];hasNodes=true;minX=Math.min(minX,n.x);maxX=Math.max(maxX,n.x+NODE_W);minY=Math.min(minY,n.y);maxY=Math.max(maxY,n.y+NODE_H+30);});
    var areaW=tpArea.clientWidth,areaH=tpArea.clientHeight;
    var treeW=hasNodes?maxX+80:0,treeH=hasNodes?maxY+80:0;
    var canvasW=Math.max(areaW,treeW),canvasH=Math.max(areaH,treeH);
    // Zoom/pan handles viewport — no scroll overflow needed
    tpCanvas.style.width=canvasW+'px';tpCanvas.style.height=canvasH+'px';
    tpSvg.setAttribute('width',canvasW);tpSvg.setAttribute('height',canvasH);
    tpSvg.style.width=canvasW+'px';tpSvg.style.height=canvasH+'px';
    Object.keys(topo.nodes).forEach(function(mac){if(!visible[mac])return;var n=topo.nodes[mac];var d=getDev(mac);if(!d)return;addTpNode(mac,n.x,n.y,d);});
    drawTpLines(visible);$('#tp-empty').toggle(!hasNodes);renderTpSidebar();
    // VLAN legend — only show on multi-VLAN networks
    if(hasMultipleVlans){
        // Show all VLANs in topology (not just visible ones) so hidden VLANs can be toggled back on
        var allVlans={};Object.keys(topo.nodes).forEach(function(m){var d=getDev(m);if(d){var v=vlan(d);if(v!=='-')allVlans[v]=1;}});
        var lg='';Object.keys(allVlans).sort(function(a,b){return+a-+b;}).forEach(function(v){
            var hidden=tpHiddenVlans[v];
            var col=VLAN_COLORS[v]||'#888';
            lg+='<span class="tp-legend-item'+(hidden?' off':'')+'" data-vlan="'+v+'" style="cursor:pointer">';
            lg+='<span class="tp-vl-dot" style="width:8px;height:8px;border-radius:2px;background:'+col+';flex-shrink:0"></span>';
            lg+='<span class="tp-vl-name">'+esc(VLAN_NAMES[v]||'VLAN '+v)+'</span>';
            lg+='<i class="fa fa-eye'+(hidden?'-slash':'')+'" style="font-size:9px;opacity:.35;margin-left:1px"></i>';
            lg+='</span>';
        });
        $('#tp-legend').html(lg).show();
        $('#tp-f-infra').show();
    }else{
        $('#tp-legend').hide();
        $('#tp-f-infra').hide();
    }
    // Re-enable transitions and re-apply selection highlight
    requestAnimationFrame(function(){
        tpCanvas.classList.remove('no-anim');
        if(_selHighlightMac&&topo.nodes[_selHighlightMac]){
            var m=_selHighlightMac;_selHighlightMac=null;applyPathHighlight(m);
        }
    });
}

function addTpNode(mac,x,y,d){
    var n=topo.nodes[mac],el=document.createElement('div');
    el.className='tp-node'+(tpSelected[mac]?' selected':'');el.dataset.mac=mac;
    el.style.left=x+'px';el.style.top=y+'px';
    var col=vlanColor(d);
    el.style.setProperty('--glow-color',col);
    var port=n&&n.port?'<span class="tn-port" data-mac="'+mac+'">'+esc(n.port)+'</span>':'';
    el.innerHTML='<div class="tn-box">'+ico(d)+(d.online?'<div class="tn-online"></div>':'')+'</div>'+port+'<div class="tn-label">'+esc(dn(d)||d.mac)+'</div><div class="tn-sublabel">'+esc(d.ip)+'</div>';
    // Hover: highlight connected path
    el.addEventListener('mouseenter',function(){
        if(tpDragging||_selHighlightMac)return;
        clearTimeout(_hoverLeaveTimer);
        var d=getDev(mac);
        var hoverCol=d?vlanColor(d):'#999';
        // Clear any previous highlight first
        var oldPath=tpCanvas.querySelectorAll('.tp-path');
        for(var i=0;i<oldPath.length;i++)oldPath[i].classList.remove('tp-path');
        var oldLines=tpSvg.querySelectorAll('.tp-line-path');
        for(var i=0;i<oldLines.length;i++){
            var oc=oldLines[i].getAttribute('data-color');
            if(oc)oldLines[i].setAttribute('stroke',oc);
            oldLines[i].classList.remove('tp-line-path');
        }
        // Only trace UP to root
        var pathMacs={};pathMacs[mac]=true;
        var cur=mac;
        while(topo.nodes[cur]&&topo.nodes[cur].parent){cur=topo.nodes[cur].parent;pathMacs[cur]=true;}
        tpWorld.classList.add('tp-hovering');
        var nodes=tpCanvas.querySelectorAll('.tp-node');
        for(var i=0;i<nodes.length;i++){
            if(pathMacs[nodes[i].dataset.mac])nodes[i].classList.add('tp-path');
        }
        var paths=tpSvg.querySelectorAll('path[data-mac]');
        for(var i=0;i<paths.length;i++){
            var m=paths[i].getAttribute('data-mac');
            if(m&&pathMacs[m]){paths[i].setAttribute('stroke',hoverCol);paths[i].classList.add('tp-line-path');}
        }
        var circles=tpSvg.querySelectorAll('circle[data-mac]');
        for(var i=0;i<circles.length;i++){
            var m=circles[i].getAttribute('data-mac');
            if(m&&pathMacs[m])circles[i].setAttribute('fill',hoverCol);
        }
    });
    el.addEventListener('mouseleave',function(){
        if(_selHighlightMac)return;
        _hoverLeaveTimer=setTimeout(function(){
            // Don't clear if selection highlight was applied in the meantime
            if(_selHighlightMac)return;
            tpWorld.classList.remove('tp-hovering');
            var marked=tpCanvas.querySelectorAll('.tp-path');
            for(var i=0;i<marked.length;i++)marked[i].classList.remove('tp-path');
            var glowPaths=tpSvg.querySelectorAll('.tp-line-path');
            for(var i=0;i<glowPaths.length;i++){
                var c=glowPaths[i].getAttribute('data-color');
                if(c)glowPaths[i].setAttribute('stroke',c);
                glowPaths[i].classList.remove('tp-line-path');
            }
            var circles=tpSvg.querySelectorAll('circle[data-mac]');
            for(var i=0;i<circles.length;i++){
                var c=circles[i].getAttribute('data-color');
                if(c)circles[i].setAttribute('fill',c);
            }
        },40);
    });
    var startX,startY;
    el.addEventListener('mousedown',function(e){
        if(e.target.closest('.tn-port'))return;
        e.preventDefault();e.stopPropagation();
        startX=e.clientX;startY=e.clientY;
        tpDragging=mac;tpDidDrag=false;

        var r=el.getBoundingClientRect();
        // Compute drag offset in world coordinates
        var aRect=tpArea.getBoundingClientRect();
        tpDragOff.x=(e.clientX-aRect.left-tpPanX)/tpZoom-topo.nodes[mac].x;
        tpDragOff.y=(e.clientY-aRect.top-tpPanY)/tpZoom-topo.nodes[mac].y;
        // If this node is in the selection, prepare group drag offsets
        if(tpSelected[mac]&&Object.keys(tpSelected).length>1){
            var offsets={};
            Object.keys(tpSelected).forEach(function(m){
                if(topo.nodes[m])offsets[m]={dx:topo.nodes[m].x-topo.nodes[mac].x,dy:topo.nodes[m].y-topo.nodes[mac].y};
            });
            tpGroupDrag={offsets:offsets};
        }else{
            tpGroupDrag=null;
        }
    });
    el.addEventListener('mouseup',function(e){
        if(e.button!==0)return;// Only left-click opens detail panel
        if(startX!==undefined){
            var dx=Math.abs(e.clientX-startX),dy=Math.abs(e.clientY-startY);
            if(dx<5&&dy<5){
                // Click — handle selection
                if(e.ctrlKey||e.metaKey){
                    // Toggle this node in multi-select
                    if(tpSelected[mac])delete tpSelected[mac];else tpSelected[mac]=true;
                    updateTpSelection();
                }else{
                    // Single select
                    tpSelected={};tpSelected[mac]=true;
                    updateTpSelection();
                    var c=getDev(mac);
                    if(c){tpSelMac=mac;selMac=mac;showDetail('tp-detail',c);applyPathHighlight(mac);}
                }
            }
        }
        startX=undefined;
    });
    el.addEventListener('dblclick',function(e){
        e.preventDefault();e.stopPropagation();
        // Auto-arrange this node's children (or siblings if leaf)
        var n=topo.nodes[mac];if(!n)return;
        var visible=getFilteredNodes();
        var ch=getChildren(mac).filter(function(m){return visible[m];});
        if(ch.length>0){
            // Has children — arrange them
            arrangeChildren(mac);
        }else if(n.parent&&topo.nodes[n.parent]){
            // Leaf node — arrange all siblings under parent
            arrangeChildren(n.parent);
        }else{
            // Root node with no children — center in viewport
            topo.nodes[mac].x=Math.max(40,(tpArea.clientWidth||800)/2-NODE_W/2);
            topo.nodes[mac].y=40;
        }
        markDirty();rebuildTopo();
    });
    var pb=el.querySelector('.tn-port');if(pb)pb.addEventListener('click',function(e){e.stopPropagation();openTpPort(mac,e.clientX,e.clientY);});
    el.addEventListener('contextmenu',function(e){e.preventDefault();e.stopPropagation();showCtxMenu(mac,e.clientX,e.clientY);});
    tpCanvas.appendChild(el);
}

function updateTpSelection(){
    var nodes=tpCanvas.querySelectorAll('.tp-node');
    for(var i=0;i<nodes.length;i++){
        var m=nodes[i].dataset.mac;
        if(tpSelected[m])nodes[i].classList.add('selected');
        else nodes[i].classList.remove('selected');
    }
    var cnt=Object.keys(tpSelected).length;
    var sc=document.getElementById('tp-sel-count');
    if(sc){if(cnt>1){sc.textContent=cnt+' selected';sc.style.display='';}else{sc.style.display='none';}}
}
function removeTpNode(mac){
    // Unparent children, don't cascade delete
    getChildren(mac).forEach(function(m){topo.nodes[m].parent=null;topo.nodes[m].port=null;});
    delete topo.nodes[mac];
}

function drawTpLines(visible){
    var h='';
    Object.keys(topo.nodes).forEach(function(mac){
        if(visible&&!visible[mac])return;
        var n=topo.nodes[mac];if(!n.parent||!topo.nodes[n.parent])return;
        if(visible&&!visible[n.parent])return;
        var p=topo.nodes[n.parent];
        var d=getDev(mac);
        var col=d?vlanColor(d):'#888';
        var x1=p.x+NODE_W/2, y1=p.y+48;
        var x2=n.x+NODE_W/2, y2=n.y+2;
        var dy=Math.abs(y2-y1)*0.6;
        var c1x=x1, c1y=y1+dy;
        var c2x=x2, c2y=y2-dy;
        // Store speed/port/vlan as data attrs for hover tooltip
        var spd=n.speed||'';
        var prt=n.port||'';
        var vl=d?vlan(d):'-';
        h+='<path data-mac="'+mac+'" data-color="'+col+'" data-speed="'+esc(spd)+'" data-port="'+esc(prt)+'" data-vlan="'+esc(vl)+'" d="M'+x1+','+y1+' C'+c1x+','+c1y+' '+c2x+','+c2y+' '+x2+','+y2+'" fill="none" stroke="'+col+'" stroke-width="1" opacity=".2"/>';
        h+='<circle data-mac="'+mac+'" data-color="'+col+'" data-end="p" cx="'+x1+'" cy="'+y1+'" r="2" fill="'+col+'" opacity=".3"/>';
        h+='<circle data-mac="'+mac+'" data-color="'+col+'" data-end="c" cx="'+x2+'" cy="'+y2+'" r="2" fill="'+col+'" opacity=".3"/>';
    });
    tpSvg.innerHTML=h;
}

function tpMM(e){
// Helper: convert screen coords to world coords (accounting for zoom/pan)
function screenToWorld(sx,sy){
    var rect=tpArea.getBoundingClientRect();
    return{x:(sx-rect.left-tpPanX)/tpZoom,y:(sy-rect.top-tpPanY)/tpZoom};
}
if(tpPanning)return;// Pan is handled separately
if(tpLasso){
    var wc=screenToWorld(e.clientX,e.clientY);
    var cx=wc.x,cy=wc.y;
    var lx=Math.min(tpLasso.startX,cx),ly=Math.min(tpLasso.startY,cy);
    var lw=Math.abs(cx-tpLasso.startX),lh=Math.abs(cy-tpLasso.startY);
    tpLasso.el.style.left=lx+'px';tpLasso.el.style.top=ly+'px';
    tpLasso.el.style.width=lw+'px';tpLasso.el.style.height=lh+'px';
    if(!tpLasso.additive)tpSelected={};
    var visible=getFilteredNodes();
    Object.keys(topo.nodes).forEach(function(m){if(!visible[m])return;var n=topo.nodes[m],nx=n.x+NODE_W/2,ny=n.y+30;if(nx>=lx&&nx<=lx+lw&&ny>=ly&&ny<=ly+lh)tpSelected[m]=true;});
    updateTpSelection();return;
}
if(!tpDragging||activeTab!=='topology')return;
var wc=screenToWorld(e.clientX,e.clientY);
var x=wc.x-tpDragOff.x,y=wc.y-tpDragOff.y;
// Constrain to positive coords
x=Math.max(0,x);y=Math.max(0,y);
var el=tpCanvas.querySelector('[data-mac="'+tpDragging+'"]');
if(el){
    var dx=Math.abs(x-topo.nodes[tpDragging].x),dy=Math.abs(y-topo.nodes[tpDragging].y);
    if(dx>4||dy>4)tpDidDrag=true;
    if(tpDidDrag){
        if(tpGroupDrag){
            var moveX=x-topo.nodes[tpDragging].x,moveY=y-topo.nodes[tpDragging].y;
            Object.keys(tpGroupDrag.offsets).forEach(function(m){var nd=tpCanvas.querySelector('[data-mac="'+m+'"]');if(nd&&topo.nodes[m]){topo.nodes[m].x=Math.max(0,topo.nodes[m].x+moveX);topo.nodes[m].y=Math.max(0,topo.nodes[m].y+moveY);nd.style.left=topo.nodes[m].x+'px';nd.style.top=topo.nodes[m].y+'px';}});
        }else{
            topo.nodes[tpDragging].x=x;topo.nodes[tpDragging].y=y;
            el.style.left=x+'px';el.style.top=y+'px';
        }
        // Update world size
        var maxX=0,maxY=0;Object.keys(topo.nodes).forEach(function(m){var n=topo.nodes[m];maxX=Math.max(maxX,n.x+NODE_W+40);maxY=Math.max(maxY,n.y+NODE_H+60);});
        tpCanvas.style.width=maxX+'px';tpCanvas.style.height=maxY+'px';
        tpSvg.setAttribute('width',maxX);tpSvg.setAttribute('height',maxY);
        tpSvg.style.width=maxX+'px';tpSvg.style.height=maxY+'px';
        drawTpLines(getFilteredNodes());el.classList.add('dragging');
    }
}
var _lastDropCheck=0;
if(tpDidDrag&&!tpGroupDrag){var now=Date.now();if(now-_lastDropCheck>66){_lastDropCheck=now;tpCheckDrop(e.clientX,e.clientY,tpDragging);}}
}
function tpMU(e){
if(tpLasso){tpLasso.el.remove();tpLasso=null;return;}
if(!tpDragging)return;var el=tpCanvas.querySelector('[data-mac="'+tpDragging+'"]');if(el)el.classList.remove('dragging');
if(tpDidDrag)markDirty();
if(tpDidDrag&&!tpGroupDrag&&tpDropTarget&&tpDropTarget!==tpDragging){
    // Prevent circular parenting: don't allow parenting to own descendant
    var descendants=getDescendants(tpDragging);
    if(descendants.indexOf(tpDropTarget)===-1){
        var portNum=getChildren(tpDropTarget).length+1;
        topo.nodes[tpDragging].parent=tpDropTarget;
        if(!topo.nodes[tpDragging].port&&!isWifiAP(tpDropTarget))topo.nodes[tpDragging].port='Port '+portNum;
        // Auto-arrange children under new parent with row wrapping
        arrangeChildren(tpDropTarget);
    }
    markDirty();
    // Snap to grid after drag
    if(tpDragging&&topo.nodes[tpDragging]){
        topo.nodes[tpDragging].x=snapToGrid(topo.nodes[tpDragging].x);
        topo.nodes[tpDragging].y=snapToGrid(topo.nodes[tpDragging].y);
    }
    rebuildTopo();
}
tpClearDrop();var wasDrag=tpDidDrag;tpDragging=null;tpDidDrag=false;tpGroupDrag=null;
// Redraw lines only if actually dragged (click should not redraw)
if(tpInited&&wasDrag){drawTpLines(getFilteredNodes());if(_selHighlightMac)applyPathHighlight(_selHighlightMac);}}
function tpCheckDrop(cx,cy,excl){tpClearDrop();tpDropTarget=null;var nodes=tpCanvas.querySelectorAll('.tp-node');for(var i=0;i<nodes.length;i++){if(nodes[i].dataset.mac===excl)continue;var r=nodes[i].getBoundingClientRect();if(cx>=r.left-10&&cx<=r.right+10&&cy>=r.top-10&&cy<=r.bottom+10){nodes[i].classList.add('drop-target');tpDropTarget=nodes[i].dataset.mac;}}}
function tpClearDrop(){var d=tpCanvas.querySelectorAll('.drop-target');for(var i=0;i<d.length;i++)d[i].classList.remove('drop-target');}

var _tpSidebarHash='';
function renderTpSidebar(){
    // Quick hash to skip re-render if nothing changed
    var onCount=0;allDevices.forEach(function(d){if(d.online)onCount++;});
    var placedCount=Object.keys(topo.nodes).length;
    var hash=allDevices.length+':'+onCount+':'+placedCount+':'+$('#tp-filter').val();
    if(hash===_tpSidebarHash)return;
    _tpSidebarHash=hash;
    var fl=$('#tp-filter').val()||'';fl=fl.toLowerCase();var visible=getFilteredNodes();var groups={};allDevices.forEach(function(d){var v=vlan(d);var vl=hasMultipleVlans?(v!=='-'?(VLAN_NAMES[v]||'VLAN '+v):'Other'):'all';if(!groups[vl])groups[vl]=[];if(!fl||dn(d).toLowerCase().indexOf(fl)!==-1||d.ip.indexOf(fl)!==-1)groups[vl].push(d);});var vlans=Object.keys(groups).sort(function(a,b){return(parseInt(a.replace(/[^0-9]/g,''))||999)-(parseInt(b.replace(/[^0-9]/g,''))||999);});var h='';vlans.forEach(function(v){if(!groups[v].length)return;if(hasMultipleVlans)h+='<div class="tp-grp-title">'+esc(v)+'</div>';groups[v].forEach(function(d){var placed=topo.nodes[d.mac]!==undefined;var filtered=placed&&!visible[d.mac];h+='<div class="tp-sdev'+(placed?' placed':'')+(filtered?' filtered':'')+'" data-mac="'+d.mac+'" draggable="true"><div class="tp-sdev-icon">'+ico(d)+'</div><div class="tp-sdev-info"><div class="tp-sdev-name">'+esc(dn(d)||d.mac)+'</div><div class="tp-sdev-ip">'+esc(d.ip)+'</div></div><div class="tp-sdev-dot '+(d.online?'on':'off')+'"></div></div>';});});$('#tp-sidebar-list').html(h);$('#tp-count').text(allDevices.length);}

$(document).on('dragstart','.tp-sdev',function(e){tpDragFromSidebar=this.dataset.mac;e.originalEvent.dataTransfer.setData('text/plain',this.dataset.mac);$(this).css('opacity','.4');});
$(document).on('dragend','.tp-sdev',function(){$(this).css('opacity','');tpDragFromSidebar=null;});
$('#tp-filter').on('input',function(){_tpSidebarHash='';renderTpSidebar();});

function openTpPort(mac,cx,cy){
    $('#tp-speed-popup').removeClass('show');$('#tp-cpick').removeClass('show');
    tpEditMac=mac;$('#tp-pp-input').val((topo.nodes[mac]&&topo.nodes[mac].port)||'');
    var pw=140,ph=80;
    var left=Math.min(cx,window.innerWidth-pw-10);
    var top=Math.min(cy,window.innerHeight-ph-10);
    left=Math.max(10,left);top=Math.max(10,top);
    $('#tp-port-popup').css({left:left,top:top}).addClass('show');$('#tp-pp-input').focus();
}
$('#tp-pp-save').on('click',function(){if(tpEditMac&&topo.nodes[tpEditMac]){topo.nodes[tpEditMac].port=$('#tp-pp-input').val();markDirty();rebuildTopo();if(selMac){var s=getDev(selMac);if(s)showDetail(activeTab==='topology'?'tp-detail':'co-detail',s);}}$('#tp-port-popup').removeClass('show');});
$('#tp-pp-cancel').on('click',function(){$('#tp-port-popup').removeClass('show');});
$('#tp-pp-input').on('keydown',function(e){if(e.which===13){e.preventDefault();$('#tp-pp-save').click();}if(e.which===27)$('#tp-port-popup').removeClass('show');});
$(document).on('click',function(e){if(!$(e.target).closest('#tp-port-popup,.tn-port,.tp-port-label').length)$('#tp-port-popup').removeClass('show');});

// ── Speed popup ──
var SPEED_OPTS=['100M','1G','2.5G','5G','10G','25G','40G','100G'];
var tpSpeedMac=null;
// Speed label click handler removed — now in context menu
$(document).on('click','.tp-speed-opt',function(e){
    e.stopPropagation();
    $('.tp-speed-opt').removeClass('sel');$(this).addClass('sel');
    $('#tp-speed-custom').val($(this).data('speed'));
});
$('#tp-sp-save').on('click',function(){
    if(tpSpeedMac&&topo.nodes[tpSpeedMac]){
        var val=$('#tp-speed-custom').val().trim();
        topo.nodes[tpSpeedMac].speed=val||null;
        markDirty();rebuildTopo();
        if(selMac){var s=getDev(selMac);if(s)showDetail(activeTab==='topology'?'tp-detail':'co-detail',s);}
    }
    $('#tp-speed-popup').removeClass('show');
});
$('#tp-sp-cancel').on('click',function(){$('#tp-speed-popup').removeClass('show');});
$('#tp-speed-custom').on('keydown',function(e){if(e.which===13){e.preventDefault();$('#tp-sp-save').click();}if(e.which===27)$('#tp-speed-popup').removeClass('show');});
$(document).on('click',function(e){if(!$(e.target).closest('#tp-speed-popup').length)$('#tp-speed-popup').removeClass('show');});

// ── Copy toast ──
var _toastTimer=null;
function showCopyToast(msg){
    var t=document.getElementById('tp-toast');
    if(!t)return;
    clearTimeout(_toastTimer);
    t.textContent=msg;t.classList.add('show');
    _toastTimer=setTimeout(function(){t.classList.remove('show');},1200);
}

// ── Right-click context menu ──
var tpCtxMac=null;
function showCtxMenu(mac,x,y){
    tpCtxMac=mac;
    var d=getDev(mac),n=topo.nodes[mac];
    var name=d?(dn(d)||d.mac):mac;
    var ip=d?d.ip:'';
    // Build type submenu
    var typeSub='';
    Object.keys(TL).forEach(function(k){
        var sel=d&&d.device_type===k?' style="font-weight:600;color:#3b82f6"':'';
        typeSub+='<div class="tp-ctx-item" data-action="type" data-val="'+k+'"'+sel+'><i class="fa fa-'+(k==='phone'?'mobile':k==='laptop'?'laptop':k==='tv'?'tv':k==='camera'?'video-camera':k==='network'?'sitemap':'cube')+'"></i>'+TL[k]+'</div>';
    });
    var h='';
    h+='<div class="tp-ctx-item" data-action="rename"><i class="fa fa-pencil"></i>Rename</div>';
    h+='<div class="tp-ctx-sub"><div class="tp-ctx-item"><i class="fa fa-tag"></i>Change Type<span class="tp-ctx-arrow">›</span></div><div class="tp-ctx-sub-menu">'+typeSub+'</div></div>';
    if(n&&n.speed!==undefined){
        h+='<div class="tp-ctx-item" data-action="speed"><i class="fa fa-bolt"></i>Set Link Speed</div>';
    }
    if(ip){h+='<div class="tp-ctx-item" data-action="copyip"><i class="fa fa-clipboard"></i>Copy IP <span style="color:#aaa;font-size:10px;margin-left:auto">'+esc(ip)+'</span></div>';}
    h+='<div class="tp-ctx-item" data-action="copymac"><i class="fa fa-clipboard"></i>Copy MAC</div>';
    if(n&&n.parent){
        h+='<div class="tp-ctx-sep"></div>';
        h+='<div class="tp-ctx-item" data-action="unparent"><i class="fa fa-unlink"></i>Disconnect from Parent</div>';
    }
    h+='<div class="tp-ctx-sep"></div>';
    h+='<div class="tp-ctx-item danger" data-action="delete"><i class="fa fa-trash"></i>Remove from Topology</div>';
    var ctx=document.getElementById('tp-ctx');
    ctx.innerHTML=h;
    // Position: ensure on screen
    ctx.style.left=Math.min(x,window.innerWidth-180)+'px';
    ctx.style.top=Math.min(y,window.innerHeight-300)+'px';
    ctx.classList.add('show');
}
function hideCtxMenu(){document.getElementById('tp-ctx').classList.remove('show');tpCtxMac=null;}
$(document).on('click','.tp-ctx-item[data-action]',function(e){
    e.stopPropagation();
    var action=$(this).data('action'),mac=tpCtxMac;
    if(!mac)return;
    var d=getDev(mac),n=topo.nodes[mac];
    hideCtxMenu();
    switch(action){
        case 'rename':
            var cur=d?(d.name||d.hostname||''):'';
            var newName=prompt('Rename device:',cur);
            if(newName!==null){
                $.post('/api/clientoverview/service/setDevice',{mac:mac,name:newName.trim()},function(){fetchClients();},'json');
            }
            break;
        case 'type':
            var val=$(this).data('val');
            if(val)$.post('/api/clientoverview/service/setDevice',{mac:mac,device_type:val},function(){fetchClients();},'json');
            break;
        case 'speed':
            // Open the existing speed popup
            var el=tpCanvas.querySelector('[data-mac="'+mac+'"]');
            if(el){var r=el.getBoundingClientRect();tpSpeedMac=mac;
                var cur2=(n&&n.speed)||'';
                var sh='';SPEED_OPTS.forEach(function(s){sh+='<span class="tp-speed-opt'+(s===cur2?' sel':'')+'">'+s+'</span>';});
                $('#tp-speed-opts').html(sh);$('#tp-speed-custom').val(cur2);
                $('#tp-speed-popup').css({left:Math.min(r.right+8,window.innerWidth-190),top:r.top}).addClass('show');
            }
            break;
        case 'copyip':
            if(d&&d.ip)navigator.clipboard.writeText(d.ip).then(function(){showCopyToast('IP copied');}).catch(function(){});
            break;
        case 'copymac':
            navigator.clipboard.writeText(mac).then(function(){showCopyToast('MAC copied');}).catch(function(){});
            break;
        case 'unparent':
            if(n){n.parent=null;n.port=null;markDirty();rebuildTopo();}
            break;
        case 'delete':
            if(confirm('Remove '+esc(d?dn(d)||d.mac:mac)+' from topology?')){
                removeTpNode(mac);markDirty();rebuildTopo();
            }
            break;
    }
});
$(document).on('click',function(e){if(!$(e.target).closest('.tp-ctx').length)hideCtxMenu();});
$(document).on('contextmenu',function(e){if(!$(e.target).closest('.tp-ctx').length)hideCtxMenu();});

// ── Line hover tooltip ──
var tpLineTip=null,tpLineTipTimer=null;
function initLineTip(){
    tpLineTip=document.getElementById('tp-line-tip');
    // Use event delegation on SVG
    tpSvg.addEventListener('mousemove',function(e){
        if(tpDragging||tpPanning)return;
        var path=e.target.closest('path[data-mac]');
        // Don't tooltip paths in selection highlight
        if(path&&path.classList.contains('tp-line-path')){hideLineTip();return;}
        if(!path){hideLineTip();return;}
        clearTimeout(tpLineTipTimer);
        var mac=path.getAttribute('data-mac');
        var n=topo.nodes[mac];
        var d=getDev(mac);
        var pDev=n&&n.parent?getDev(n.parent):null;
        var speed=path.getAttribute('data-speed')||'';
        var port=path.getAttribute('data-port')||'';
        var vl=path.getAttribute('data-vlan')||'-';
        var fromName=pDev?(dn(pDev)||pDev.mac):'?';
        var toName=d?(dn(d)||d.mac):'?';
        var h='<div style="font-weight:600;margin-bottom:3px;font-size:11px">'+esc(fromName)+' → '+esc(toName)+'</div>';
        if(port)h+='<div class="tip-row"><span class="tip-label">Port</span><b>'+esc(port)+'</b></div>';
        if(speed)h+='<div class="tip-row"><span class="tip-label">Speed</span><b>'+esc(speed)+'</b></div>';
        h+='<div class="tip-row"><span class="tip-label">VLAN</span><b>'+esc(vl)+'</b></div>';
        tpLineTip.innerHTML=h;
        var tipW=tpLineTip.offsetWidth||150,tipH=tpLineTip.offsetHeight||40;
        tpLineTip.style.left=Math.min(e.clientX+12,window.innerWidth-tipW-8)+'px';
        tpLineTip.style.top=Math.max(8,Math.min(e.clientY-10,window.innerHeight-tipH-8))+'px';
        tpLineTip.classList.add('show');
        // Highlight the line subtly
        if(_tipPath&&_tipPath!==path){_tipPath.style.strokeWidth='';_tipPath.style.opacity='';}_tipPath=path;path.style.strokeWidth='2';path.style.opacity='.5';
    });
    tpSvg.addEventListener('mouseleave',function(){hideLineTip();});
}
var _tipPath=null;
function hideLineTip(){
    if(tpLineTip)tpLineTip.classList.remove('show');
    if(_tipPath){_tipPath.style.strokeWidth='';_tipPath.style.opacity='';_tipPath=null;}
}

// ── Snap to grid ──
var GRID=18;// Matches the CSS dot grid size
function snapToGrid(v){return Math.round(v/GRID)*GRID;}

// ── VLAN color picker ──
var PALETTE=['#22c55e','#06b6d4','#a855f7','#f59e0b','#ef4444','#3b82f6','#ec4899','#14b8a6','#f97316','#8b5cf6','#64748b','#84cc16','#e11d48','#0ea5e9','#d946ef','#78716c','#fb923c','#2dd4bf'];
var cpickVlan=null;

// Load saved VLAN colors
try{var saved=JSON.parse(localStorage.getItem('co_vlan_colors')||'{}');if(saved){Object.keys(saved).forEach(function(v){var c=saved[v];if(typeof c==='string'&&/^#[0-9a-fA-F]{3,8}$/.test(c))VLAN_COLORS[v]=c;});}}catch(e){}

function saveVlanColors(){try{localStorage.setItem('co_vlan_colors',JSON.stringify(VLAN_COLORS));}catch(e){}}

// Whole legend item: toggle VLAN visibility
$(document).on('click','.tp-legend-item',function(e){
    // If clicking the color dot, don't toggle — let the dot handler fire
    if($(e.target).hasClass('tp-vl-dot'))return;
    e.stopPropagation();
    var v=$(this).data('vlan')+'';
    if(tpHiddenVlans[v]){delete tpHiddenVlans[v];}else{tpHiddenVlans[v]=true;}
    markDirty();rebuildTopo();
});
// Color dot: open color picker
$(document).on('click','.tp-vl-dot',function(e){
    e.stopPropagation();
    var item=$(this).closest('.tp-legend-item');
    cpickVlan=item.data('vlan')+'';
    var name=VLAN_NAMES[cpickVlan]||'VLAN '+cpickVlan;
    $('#tp-cpick-title').text(name+' Color');
    var cur=VLAN_COLORS[cpickVlan]||'#888';
    var h='';PALETTE.forEach(function(c){h+='<div class="tp-cpick-swatch'+(c===cur?' sel':'')+'" data-color="'+c+'" style="background:'+c+'"></div>';});
    $('#tp-cpick-grid').html(h);
    $('#tp-cpick-custom').val(cur);
    var r=this.getBoundingClientRect();
    var cpEl=$('#tp-cpick');
    cpEl.addClass('show');
    var cpW=cpEl.outerWidth()||200;
    var posLeft=r.left;
    // If picker would overflow right edge, flip to left
    if(posLeft+cpW>window.innerWidth-12)posLeft=window.innerWidth-cpW-12;
    if(posLeft<12)posLeft=12;
    cpEl.css({left:posLeft,top:r.bottom+4});
});
$(document).on('click','.tp-cpick-swatch',function(){
    var c=$(this).data('color');
    if(cpickVlan){VLAN_COLORS[cpickVlan]=c;saveVlanColors();}
    $('#tp-cpick').removeClass('show');rebuildTopo();
});
$('#tp-cpick-custom').on('input',function(){
    var c=$(this).val();
    if(cpickVlan&&typeof c==='string'&&/^#[0-9a-fA-F]{3,8}$/.test(c)){VLAN_COLORS[cpickVlan]=c;saveVlanColors();rebuildTopo();}
});
$(document).on('click',function(e){if(!$(e.target).closest('#tp-cpick,.tp-vl-dot').length)$('#tp-cpick').removeClass('show');});

$('#tp-save').on('click',saveTopo);

// ── Port management ──
// Detach device from parent (remove port connection)
$(document).on('click','.tp-detach-port',function(e){
    e.stopPropagation();
    var mac=$(this).data('mac');if(!mac||!topo.nodes[mac])return;
    topo.nodes[mac].parent=null;
    topo.nodes[mac].port=null;
    markDirty();rebuildTopo();
    if(selMac){var s=getDev(selMac);if(s)showDetail(activeTab==='topology'?'tp-detail':'co-detail',s);}
});

// Click port label in port manager to rename
$(document).on('click','.tp-port-label',function(e){
    e.stopPropagation();
    var mac=$(this).data('mac');if(!mac||!topo.nodes[mac])return;
    var cur=topo.nodes[mac].port||'';
    var rect=this.getBoundingClientRect();
    openTpPort(mac,rect.left,rect.bottom+4);
});

// Add port button - just a helper tooltip
$(document).on('click','.tp-add-port-btn',function(){
    var b=$(this);
    b.html('<i class="fa fa-info-circle" style="margin-right:3px"></i>Drag a device onto this switch');
    setTimeout(function(){b.html('<i class="fa fa-plus" style="margin-right:3px"></i>Add');},2500);
});
$('#tp-refresh').on('click',function(){var b=$(this);b.find('i').addClass('fa-spin');fetchClients();loadTopo();setTimeout(function(){b.find('i').removeClass('fa-spin');},800);});
$(document).on('click','.tp-remove-btn',function(){var mac=$(this).data('mac');if(mac&&topo.nodes[mac]){removeTpNode(mac);tpSelMac=null;$('#tp-detail').addClass('hidden');markDirty();rebuildTopo();}});
$('#tp-clear').on('click',function(){if(confirm('Clear topology?')){topo={nodes:{}};tpSelMac=null;$('#tp-detail').addClass('hidden');markDirty();rebuildTopo();}});
$('#tp-auto').on('click',function(){autoLayoutTree();markDirty();rebuildTopo();setTimeout(fitToView,50);});
$('#tp-fit').on('click',function(){fitToView();});

// Filter toggles
$('#tp-f-infra').on('click',function(){
    tpFilters.infra=!tpFilters.infra;
    $(this).toggleClass('active',tpFilters.infra);
    if(tpFilters.infra){tpFilters.wired=false;$('#tp-f-wired').removeClass('active');}
    rebuildTopo();
});
$('#tp-f-wired').on('click',function(){
    tpFilters.wired=!tpFilters.wired;
    $(this).toggleClass('active',tpFilters.wired);
    if(tpFilters.wired){tpFilters.infra=false;$('#tp-f-infra').removeClass('active');}
    rebuildTopo();
});
$('#tp-f-online').on('click',function(){
    tpFilters.online=!tpFilters.online;
    $(this).toggleClass('active',tpFilters.online);
    rebuildTopo();
});

// Recalculate container sizes on window resize
var resizeTimer;
$(window).on('resize',function(){clearTimeout(resizeTimer);resizeTimer=setTimeout(function(){sizeContainers();if(activeTab==='topology')rebuildTopo();},300);});

// Init
// Load topology data first so clients tab can show topology path
$.ajax({url:'/api/clientoverview/service/topology',type:'GET',dataType:'json',
    success:function(d){
        var nc=d&&d.topology&&d.topology.nodes?Object.keys(d.topology.nodes).length:0;
        console.log('Initial topo load: '+nc+' nodes');
        if(d&&d.topology&&d.topology.nodes)topo=d.topology;
    },
    error:function(){},
    complete:function(){fetchClients();
        var pollTimer=setInterval(fetchClients,30000);
        document.addEventListener('visibilitychange',function(){
            if(document.hidden){clearInterval(pollTimer);pollTimer=null;}
            else{fetchClients();pollTimer=setInterval(fetchClients,30000);}
        });
    }
});
});
</script>
