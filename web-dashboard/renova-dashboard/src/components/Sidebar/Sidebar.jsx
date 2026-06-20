import "./Sidebar.css";
// Material UI Icons
import HomeIcon from '@mui/icons-material/Home';
import SettingsIcon from '@mui/icons-material/Settings';
export default function Sidebar() {
    return (  
          <div className="sidebar">
        <div className="sidebar-header">
                    <img src="/assets/images/logo.png" alt="Logo" width="78" height="78" />
                <div className="logo-text">
                    <h2>ري<span>ن</span>وفا</h2>
                    <p>نظام إعادة الإعمار الذكي</p>
                </div>
        </div>
        <div className="sidebar-menu">
            <div className="menu-btn active">
                <HomeIcon />
                <span>الصفحة الرئيسية</span>
            </div>
            <div className="menu-btn">
                <SettingsIcon />
                <span>الإعدادات</span>
            </div>
        </div>
    </div>
    );
}