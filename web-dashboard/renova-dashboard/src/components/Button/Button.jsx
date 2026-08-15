import "./Button.css";
//Hooks
import { useTranslation } from "react-i18next";
export default function Button({ type="", text, onClick, className = "",icon="", bgc="" }) {
    const { t } = useTranslation();
  return (
    <button type={type} className={className} onClick={onClick} style={{backgroundColor:bgc}}>
      {icon}
      {t(text)}
    </button>
  );
}