import './Errordialog.css';
//MUI Icons
import RefreshIcon from '@mui/icons-material/Refresh';
import GppMaybeIcon from '@mui/icons-material/GppMaybe';
//Hooks
import { useTranslation } from 'react-i18next';
//Components
import Button from '../Button/Button';
export default function Errordialog({message ,onClose}){
    const { t } = useTranslation();

    return (
    <div>
        <div className="error-dialog-overlay" id="dialogOverlay">
        <div className="error-dialog-box">
            <div className="error-icon-wrapper">
                <GppMaybeIcon sx={{fontSize: 50 , color:"#e53935" ,}}/>
            </div>
            <h3>{t("فشل المصادقة")}</h3>
                <p>{t(message)}</p>
                <Button className="try-again" text="اعادة المحاولة" onClick={onClose} icon={<RefreshIcon/>}/>
        </div>
    </div>

    </div>
  );
}