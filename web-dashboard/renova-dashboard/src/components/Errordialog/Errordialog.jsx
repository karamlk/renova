import './Errordialog.css';
import RefreshIcon from '@mui/icons-material/Refresh';
import GppMaybeIcon from '@mui/icons-material/GppMaybe';
import { useTranslation } from 'react-i18next';

export default function Errordialog({message ,onClose}){
    const { t } = useTranslation();

    return (
    <div>
        <div className="dialog-overlay" id="dialogOverlay">
        <div className="dialog-box">
            <div className="icon-wrapper">
                <GppMaybeIcon sx={{fontSize: 50 , color:"#e53935" ,}}/>
            </div>
            <h3>{t("فشل المصادقة")}</h3>
                <p>{t(message)}</p>
            <button className="btn-primary" onClick={onClose} >
                <RefreshIcon/>
               {t("اعادة المحاولة")}
            </button>
        </div>
    </div>

    </div>
  );
}