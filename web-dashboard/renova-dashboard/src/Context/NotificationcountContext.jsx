import { createContext, useState } from "react";
export const NotificationcountContext = createContext();

export default function NotificationcountProvider({ children }) {
    const [N_count, setN_count] = useState(null);
    return (
        <NotificationcountContext.Provider value={{ N_count, setN_count }}>
            {children}
        </NotificationcountContext.Provider>
    );
}