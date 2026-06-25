import './Errordialog.css';
import RefreshIcon from '@mui/icons-material/Refresh';
import GppMaybeIcon from '@mui/icons-material/GppMaybe';
export default function Errordialog({message ,onClose}){
    return (
    <div>
        <div className="dialog-overlay" id="dialogOverlay">
        <div className="dialog-box">
            <div className="icon-wrapper">
                <GppMaybeIcon sx={{fontSize: 50 , color:"#e53935" ,}}/>
            </div>
            <h3>فشل المصادقة</h3>
                <p>{message}</p>
            <button className="btn-primary" onClick={onClose} >
                <RefreshIcon/>
                إعادة المحاولة
            </button>
        </div>
    </div>

    </div>
  );
}