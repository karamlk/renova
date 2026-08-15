import "./Projecttable.css";
import "../../pages/Users/Table.css"
//Hooks
import { useTranslation } from 'react-i18next';
//MUI Icons
import LocationOnIcon from '@mui/icons-material/LocationOn';
import AssignmentIcon from '@mui/icons-material/Assignment';
import FilterAltIcon from '@mui/icons-material/FilterAlt';
import RefreshIcon from '@mui/icons-material/Refresh';
export default function Projecttable() {
    const [t]=useTranslation();
    const projects = [
  {
    id: 1,
    name: "مجمع الزيتون السكني",
    username:"عمر",
    location: "غزة",
    type: "إعادة بناء",
    status: "مفتوح",
    created_at:"2023-01-01",
    progress: 65,
  },
  {
    id: 2,
    name: "مدرسة الشروق",
    username:"عمر",
    location: "حلب",
    type: "ترميم",
    status: "مفتوح",
    created_at:"2023-01-01",
    progress: 40,
  },
  {
    id: 3,
    name: "مركز الرازي الصحي",
    username:"عمر",
    location: "درعا",
    type: "إكساء",
    status: "مفتوح",
    created_at:"2023-01-01",
    progress: 100,
  },
  {
    id: 4,
    name: "مشروع مياه الخير",
    username:"عمر",
    location: "رفح",
    type: "إعادة بناء",
    status: "مفتوح",
    created_at:"2023-01-01",
    progress: 75,
  },
  {
    id: 5,
    name: "مشروع مياه الخير",
    username:"عمر",
    location: "رفح",
    type: "إعادة بناء",
    status: "مفتوح",
    created_at:"2023-01-01",
    progress: 75,
  },
  {
    id: 6,
    name: "مشروع مياه الخير",
    username:"عمر",
    location: "رفح",
    type: "إعادة بناء",
    status: "مفتوح",
    created_at:"2023-01-01",
    progress: 75,
  },

];
    return (
        <div>
        <div class="table-body">
            <div class="table-header">
                <h3><AssignmentIcon sx={{ color: "#f07c1f"}}/> {t("أحدث المشاريع")}</h3>
                <div class="table-actions">
                    <button class="btn-filter"><FilterAltIcon sx={{fontSize: "18px"}}/> {t("فلترة")}</button>
                    <button class="btn-outline"><RefreshIcon sx={{fontSize: "18px"}}/> {t("تحديث")}</button>
                </div>
            </div>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>{t("اسم المشروع")}</th>
                            <th>{t("صاحب المشروع")}</th>
                            <th>{t("الموقع")}</th>
                            <th>{t("النوع")}</th>
                            <th>{t("الحالة")}</th>
                            <th>{t("تاريخ الإنشاء")}</th>
                            <th>{t("التقدم")}</th>
                        </tr>
                    </thead>
                   <tbody>
                    {projects.map((project) => (
                        <tr key={project.id}>
                        <td>{project.name}</td>
                        <td>{project.username}</td>
                        <td className="location"><LocationOnIcon sx={{ color: "#f07c1f"}}/>{project.location}</td>
                        <td>{project.type}</td>
                        <td>{project.status}</td>
                        <td>{project.created_at}</td>
                        <td>
                            <div className="progress">
                            <div className="progress-bar">
                                <div className="progress-fill" style={{ width: `${project.progress}%` }}></div>
                            </div>
                            <span>{project.progress}%</span>
                            </div>
                        </td>
                        </tr>
                    ))}
                    </tbody>
                </table>
            </div>
        </div>
        </div>
       
    )
}