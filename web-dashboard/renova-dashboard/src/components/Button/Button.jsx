import "./Button.css";
//Hooks
import { useTranslation } from "react-i18next";
export default function Button({ form="",type="", text, onClick, className = "",icon="", bgc="" }) {
    const { t } = useTranslation();
  return (
    <button form ={form} type={type} className={className} onClick={onClick} style={{backgroundColor:bgc}}>
      {icon}
      {t(text)}
    </button>
  );
}